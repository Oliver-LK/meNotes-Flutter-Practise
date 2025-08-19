import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:me_notes/firebase_options.dart';


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
                final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email, 
                  password: password
                );
                print(userCredential);
      
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login successful!")),
                );
      
              } on FirebaseAuthException catch (e) {
                late String message;
      
                if (e.code == 'invalid-credential') {
                  message = "User Not Found.";
                  print("User Not Found");
      
                } else if (e.code == 'wrong-password') {
                  message = "Wrong Password";
                  print("Wrong Password");
      
                } else if (e.code == 'channel-error') {
                  message = "Please Enter Your Email & Password";
      
                } else {
                  print("Something else Happened");
                  message = "Something Bad Happened.";
                  print(e.code);
                }
      
                print(e.code);
      
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
      
              );
      
              } catch (e) {
                print('Something Bad Happened');
                print(e.runtimeType);
              }
              
            },
            child: const Text('Login')),
      
            TextButton(onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/', 
                (route) => false,
              );
            }, 
            
            child: const Text('Register Here'))
        ],
      ),
    );
  }    
}