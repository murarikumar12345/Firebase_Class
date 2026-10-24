import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/utils/utils.dart';

import 'fire_stroe_screen.dart';

class FireList extends StatefulWidget {
  FireList({super.key});

  @override
  State<FireList> createState() => _FireListState();
}

class _FireListState extends State<FireList> {
  final ediitcont = TextEditingController();
  final firestorer = FirebaseFirestore.instance.collection('user').snapshots();
  final fire = FirebaseFirestore.instance.collection('user');
  //  final refA=FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('firestore list'),
        centerTitle: true,
        automaticallyImplyActions: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FireStroeScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          StreamBuilder<QuerySnapshot>(
            stream: firestorer,

            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final docId=doc.id;
                          final title=doc['title'].toString();
                          return ListTile(
                            onTap: () {
                              fire
                                  .doc(
                                    snapshot.data!.docs[index]['id'].toString(),
                                  )
                                  .update({
                                    'title': ediitcont.text.toString(),
                                    'id': snapshot.data!.docs[index]['id']
                                        .toString(),
                                  })
                                  .then((value) {
                                    utils().toastmessage('post updated');
                                  })
                                  .onError((error, stackTrace) {
                                    utils().toastmessage(error.toString());
                                  });
                            },
                            title:Text(title),
                            subtitle: Text(docId),
                            trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);{
                                        showMyDialog(title,docId);
                                      };
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
                                      fire.doc(docId).delete().then((value){
                                        utils().toastmessage('Post deleted');

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
                        },
                      ),
                    );
                  }
                },
          ),
        ],
      ),
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
                fire.doc(id).update({
                  'title': ediitcont.text.toString(),
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



///this is  the firestore list code in  program //