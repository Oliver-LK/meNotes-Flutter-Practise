import 'package:flutter/material.dart';
import 'package:me_notes/constants/error_names.dart';
import 'package:me_notes/constants/routes.dart';
import 'package:me_notes/services/auth/auth_exceptions.dart';
import 'package:me_notes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import 'package:me_notes/utilities/error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super (key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login Page'),
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
                await AuthService.firebase().logIn(
                  email: email, 
                  password: password
                );

                final user = AuthService.firebase().currentUser;

                if (user?.isEmailVerified == true) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute, 
                  (route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                  verifyEmailRoute, 
                  (route) => false);
                }
      
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login successful!")),
                );
                
              } on UserNotFoundAuthException {
                await showErrorDialog(context, "Invalid Credentials.", loginErrorString);

              } on WrongPasswordAuthException {
                await showErrorDialog(context, "Wrong Password", loginErrorString);

              } on InvalidEmailAuthException {
                await showErrorDialog(context, "Invalid Email", loginErrorString);

              } on GenericAuthException {
                await showErrorDialog(context, "Something else Happened", loginErrorString);
              }
            },
            child: const Text('Login')),
      
            TextButton(onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute, 
                (route) => false,
              );
            }, 
            child: const Text('Register Here'))
        ],
      ),
    );
  }    
}