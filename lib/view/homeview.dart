import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/utils/utils.dart';
import 'package:flutterproject/view/auth/addpost_screen.dart';
import 'package:flutterproject/view/auth/animation_screen.dart';
import 'package:flutterproject/view/auth/login_screen.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final search = TextEditingController();
  final ediitcont = TextEditingController();

  // Note: Leading dot '.' is REQUIRED for Firebase system connection node: '.info/connected'
  final Stream<DatabaseEvent> _stream =
      FirebaseDatabase.instance.ref('.info/connected').onValue;

  @override
  void dispose() {
    search.dispose();
    ediitcont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: _stream,
      builder: (context, snapshot) {
        final bool isOffline =
            snapshot.data?.snapshot.value as bool? ?? true;

        if (!isOffline) {
          return const FullScreenOfflineAnimation();
        }
         else{
         return Scaffold(
           appBar: AppBar(
             title: const Text('Post'),
             automaticallyImplyLeading: false,
             centerTitle: true,
             actions: [
               IconButton(
                 onPressed: () {
                   auth.signOut().then((value) {
                     if (mounted) {
                       Navigator.pushAndRemoveUntil(
                         context,
                         MaterialPageRoute(
                           builder: (context) => const LoginScreen(),
                         ),
                             (route) => false,
                       );
                     }
                   }).onError((error, stackTrace) {
                     utils().toastmessage(error.toString());
                   });
                 },
                 icon: const Icon(Icons.logout_outlined, color: Colors.white),
               ),
             ],
           ),
           floatingActionButton: FloatingActionButton(
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const AddpostScreen()),
               );
             },
             child: const Icon(Icons.add),
           ),
           body: Column(
             children: [
               const SizedBox(height: 15),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 15),
                 child: TextFormField(
                   controller: search,
                   decoration: const InputDecoration(
                     hintText: 'Search',
                     border: OutlineInputBorder(),
                   ),
                   onChanged: (String value) {
                     setState(() {});
                   },
                 ),
               ),
               Expanded(
                 child: FirebaseAnimatedList(
                   query: ref,
                   itemBuilder: (context, snapshot, animation, index) {
                     final title = snapshot
                         .child('title')
                         .value
                         .toString();
                     final id = snapshot
                         .child('id')
                         .value
                         .toString();

                     if (search.text.isEmpty ||
                         title.toLowerCase().contains(
                           search.text.toLowerCase().trim(),
                         )) {
                       return ListTile(
                         title: Text(title),
                         subtitle: Text(id),
                         trailing: PopupMenuButton(
                           icon: const Icon(Icons.more_vert),
                           itemBuilder: (context) => [
                             PopupMenuItem(
                               value: 1,
                               child: ListTile(
                                 onTap: () {
                                   Navigator.pop(context);
                                   showMyDialog(title, id);
                                 },
                                 leading: const Icon(Icons.edit),
                                 title: const Text('Edit'),
                               ),
                             ),
                             PopupMenuItem(
                               value: 2,
                               child: ListTile(
                                 onTap: () {
                                   Navigator.pop(context);
                                   ref.child(snapshot.child('id').value.toString()).remove().then((value) {
                                     utils().toastmessage("Post Deleted");
                                   }).onError((error, stackTrace) {
                                     utils().toastmessage(error.toString());
                                   });
                                 },
                                 leading: const Icon(Icons.delete),
                                 title: const Text('Delete'),
                               ),
                             ),
                           ],
                         ),
                       );
                     } else {
                       return Container();
                     }
                   },
                 ),
               ),
             ],
           ),
         );
        }
      },
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    ediitcont.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            controller: ediitcont,
            decoration: const InputDecoration(hintText: 'Edit here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.child(id).update({
                  'title': ediitcont.text,
                }).then((value) {
                  utils().toastmessage("Post Updated");
                }).onError((error, stackTrace) {
                  utils().toastmessage(error.toString());
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
