import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/utils/utils.dart';
import 'package:flutterproject/view/auth/verifycode.dart';
import 'package:flutterproject/widget/roundbutton.dart';

class LoginwithPhoneno extends StatefulWidget {
  const LoginwithPhoneno({super.key});

  @override
  State<LoginwithPhoneno> createState() => _LoginwithPhonenoState();
}

class _LoginwithPhonenoState extends State<LoginwithPhoneno> {
  bool loading = false;
  final phonenocontroller = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    phonenocontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone Number')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phonenocontroller,
                decoration: const InputDecoration(hintText: " +122 1235 782"),
              ),
            ),
            const SizedBox(height: 15),
            Roundbutton(
              title: "Login",
              loading: loading,
              ontap: () {
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                  phoneNumber: '+91${phonenocontroller.text.trim()}',
                  verificationCompleted: (_) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e) {
                    utils().toastmessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  },
                  codeSent: (String verificationId, int? token) {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Verifycode(
                            verificationId: verificationId,
                          ),
                        ),
                      );
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (e) {
                    utils().toastmessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
