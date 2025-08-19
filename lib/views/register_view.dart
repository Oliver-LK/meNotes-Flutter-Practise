

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:me_notes/firebase_options.dart';

class RegsiterView extends StatefulWidget {
  const RegsiterView({super.key});

  @override
  State<RegsiterView> createState() => _RegsiterViewState();
}

class _RegsiterViewState extends State<RegsiterView> {

  // late means no value assigned initially but we promise we will
  late final TextEditingController _email;
  late final TextEditingController _password;

  // Performs one time inits for data w late
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  // Dispose of data afterwards
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Username
        TextField(
          controller: _email,
          obscureText: false,
          enableSuggestions: true,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: 'Enter your Email',
          ),
        ),
        // Password
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: 'Enter your Password',
          ),
        ),
        // Register Button
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;

            try {
              final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email, 
                password: password
              );
              print(userCredential);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration successful!")),
              );

            } on FirebaseAuthException catch (e) {
              late String message;

              if (e.code == 'weak-password') {
                message = "Password must be at least 6 characters.";
                print("Password must be at least 6 characters");

              } else if(e.code == 'email-already-in-use') {
                message = "Email already in use.";
                print("Email already in use");
              } else if (e.code == 'invalid-email') {
                message = "Invalid Email";
                print('Invalid Email');
              } else {
                message = "Something went very wrong";
                print('Something went Very wrong');
              }

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );

              print(e.code);
            }

          },
          child: const Text('Register')),
      ],
    );
  }
}

