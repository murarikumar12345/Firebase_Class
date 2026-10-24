import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/utils/utils.dart';
import 'package:flutterproject/widget/roundbutton.dart';


class FireStroeScreen extends StatefulWidget {
  const FireStroeScreen({super.key});

  @override
  State<FireStroeScreen> createState() => _FireStroeScreenState();
}

class _FireStroeScreenState extends State<FireStroeScreen> {
  final ediitcont = TextEditingController();
   bool loading = false;
  final firestorer = FirebaseFirestore.instance.collection('user');
  @override
  void dispose() {
    ediitcont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add firestore data'),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  child: TextFormField(
                    controller: ediitcont,
                    decoration: const InputDecoration(
                      hintText: 'what is on your mind?',
                      border: OutlineInputBorder(),
                    ),

                  ),
                ),
              SizedBox(
                height: 15,
              ),
                Roundbutton(
                  title: 'Add',
                  loading: loading,
                  ontap: (){
                    setState(() {
                      loading=true;
                    });
                    String id=DateTime.now().millisecondsSinceEpoch.toString();
                     firestorer.doc().set({
                       'title':ediitcont.text.toString(),
                       'id':id


                     }).then((value) {
                       utils().toastmessage('post added');
                       setState(() {
                         loading=false;
                       });

                     },).onError((error, stackTrace) {
                       utils().toastmessage(error.toString());
                       setState(() {
                         loading=false;
                       });
                     });
                  },
                )







              ]
            ),
          );
        }
  }

  // Future<void> showMyDialog(String title, String id) async {
  //   ediitcont.text = title;
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Update'),
  //         content: TextField(
  //           controller: ediitcont,
  //           decoration: const InputDecoration(hintText: 'Edit here'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               ref
  //                   .child(id)
  //                   .update({'title': ediitcont.text})
  //                   .then((value) {
  //                     utils().toastmessage("Post Updated");
  //                   })
  //                   .onError((error, stackTrace) {
  //                     utils().toastmessage(error.toString());
  //                   });
  //             },
  //             child: const Text('Update'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

