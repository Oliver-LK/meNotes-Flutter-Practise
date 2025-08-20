import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:me_notes/constants/routes.dart';
import 'package:me_notes/firebase_options.dart';
import 'dart:developer' as devtools show log;


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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email, 
                  password: password
                );
      
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login successful!")),
                );

                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute, 
                  (route) => false,
                );
      
              } on FirebaseAuthException catch (e) {
                late String message;
      
                if (e.code == 'invalid-credential') {
                  message = "User Not Found.";
                  devtools.log("User Not Found");
      
                } else if (e.code == 'wrong-password') {
                  message = "Wrong Password";
                  devtools.log("Wrong Password");
      
                } else if (e.code == 'channel-error') {
                  message = "Please Enter Your Email & Password";
      
                } else {
                  devtools.log("Something else Happened");
                  message = "Something Bad Happened.";
                  devtools.log(e.code);
                }
      
                devtools.log(e.code);
      
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
      
              } catch (e) {
                devtools.log('Something Bad Happened');
                devtools.log(e.runtimeType.toString());
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