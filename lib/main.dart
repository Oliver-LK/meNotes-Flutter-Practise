import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:me_notes/views/login_view.dart';
import 'package:me_notes/views/register_view.dart';
import 'package:me_notes/views/verify_email_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
  MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegsiterView(),
      },
    )
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Register Email and Password Feild
    return FutureBuilder(  // Future builder so Firebase init happens before everything else
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
          final user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            if (user.emailVerified == true) {
              return const NotesView();  // TAke this out and send else where

            } else {
              return const VerifyEmailView();
            }
          }

          else {
            return const LoginView();
          }

        default:
          return const CircularProgressIndicator();
        }

        // return Text('Something is wrong. In main.dart. Probably a Null error');
      }
    );
  }
}


enum MenuAction {logout}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          PopupMenuButton <MenuAction>(
            onSelected: (value) async {
              devtools.log(value.toString());
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout == true) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/', 
                      (_) => false
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem <MenuAction> (
                  value: MenuAction.logout, 
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text("Testing"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: const Text('Cancel')),

          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, child: const Text('Log Out')),
        ],
      );
    }
  ).then((value) => value ?? false);
}