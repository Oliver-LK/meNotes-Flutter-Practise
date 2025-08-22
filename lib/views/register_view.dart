

import 'package:flutter/material.dart';
import 'package:me_notes/constants/error_names.dart';
import 'package:me_notes/constants/routes.dart';
import 'package:me_notes/services/auth/auth_exceptions.dart';
import 'package:me_notes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import 'package:me_notes/utilities/error_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register View"),
      ),
      
      body: Column(
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
                await AuthService.firebase().createUser(
                  email: email, 
                  password: password
                );

                await AuthService.firebase().sendEmailVerification();

                Navigator.of(context).pushNamed(verifyEmailRoute);
      
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration successful!")),
                );
      
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email already in use.", registrationErrorString);

              } on WeakPasswordAuthException {
                await showErrorDialog(context, "Password must be at least 6 characters.", registrationErrorString);

              } on InvalidEmailAuthException {
                await showErrorDialog(context, "Invalid Email", registrationErrorString);

              } on GenericAuthException {
                await showErrorDialog(context, "Something else went wrong", registrationErrorString);
              }
              
            },
            child: const Text('Register')),

            TextButton(onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute, 
              (route) => false
              );
            }, 
            child: const Text('Login Here'))
        ],
      ),
    );
  }
}

