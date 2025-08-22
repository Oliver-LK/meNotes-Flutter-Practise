import 'package:flutter/material.dart';
import 'package:me_notes/constants/routes.dart';
import 'package:me_notes/services/auth/auth_service.dart';
import 'package:me_notes/services/auth/auth_user.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),),
         
      body: Column(
        children: [
          const Text('We have already sent you a verification email. Please open it to verify your account'),
          const Text("If you haven't received an email then click the button below."),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            }, 
            child: const Text('Send Email Verification')
          ),

          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();

              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute, 
                (route) => false
              );
            }, 
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
} 