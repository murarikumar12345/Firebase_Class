import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widget/roundbutton.dart';
import '../homeview.dart';

class Verifycode extends StatefulWidget {
  final String verificationId;
  const Verifycode({super.key, required this.verificationId});

  @override
  State<Verifycode> createState() => _VerifycodeState();
}

class _VerifycodeState extends State<Verifycode> {
  bool loading = false;
  final otpcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    otpcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login OTP Verify Code'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: otpcontroller,
              decoration: const InputDecoration(hintText: "6 digit Code"),
            ),
          ),
          const SizedBox(height: 15),
          Roundbutton(
            title: "Verify",
            loading: loading,
            ontap: () async {
              setState(() {
                loading = true;
              });
              final credential = PhoneAuthProvider.credential(
                verificationId: widget.verificationId,
                smsCode: otpcontroller.text.toString(),
              );

              try {
                await auth.signInWithCredential(credential);
                setState(() {
                  loading = false;
                });
                if (mounted) {
                  utils().toastmessage("Login Successful");
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Homeview()),
                    (route) => false,
                  );
                }
              } catch (e) {
                utils().toastmessage(e.toString());
                setState(() {
                  loading = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
