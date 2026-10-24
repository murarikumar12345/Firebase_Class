import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/widget/roundbutton.dart';

import '../../utils/utils.dart';

class AddpostScreen extends StatefulWidget {
  const AddpostScreen({super.key});

  @override
  State<AddpostScreen> createState() => _AddpostScreenState();
}

class _AddpostScreenState extends State<AddpostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: postController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "What is on your mind?",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Roundbutton(
              title: "Add",
              loading: loading,
              ontap: () {
                if (postController.text.trim().isEmpty) {
                  utils().toastmessage("Please enter some text");
                  return;
                }
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                databaseRef.child(id).set({
                  "id": DateTime.now().millisecondsSinceEpoch.toString(),
                  "title": postController.text.toString(),
                }).then((value) {
                  utils().toastmessage("Post Added");
                  postController.clear();
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  utils().toastmessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
