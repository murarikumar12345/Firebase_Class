import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firestroe/fire_list.dart';
import '../uploadimage.dart';
import '../view/auth/login_screen.dart';
import '../view/homeview.dart';

class SplashServices {
  void inlogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder: (context) => const Homeview()),
            // MaterialPageRoute(builder: (context) =>  FireList()),
             MaterialPageRoute(builder: (context) => uploading()),

          );
        }
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
    }
  }
}
