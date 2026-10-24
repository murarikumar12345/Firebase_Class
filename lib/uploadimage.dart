import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterproject/widget/roundbutton.dart';
import 'package:image_picker/image_picker.dart';

class uploading extends StatefulWidget {
  const uploading({super.key});

  @override
  State<uploading> createState() => _uploadingState();
}

class _uploadingState extends State<uploading> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected plz select image");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('uploading image ')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InkWell(
                onTap: () {
                  getImage();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 200,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Icon(Icons.image, color: Colors.amber, size: 60),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Roundbutton(title: 'Upload', ontap: () {}),
          ),
        ],
      ),
    );
  }
}
