import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:me_notes/services/auth/auth_service.dart';
import 'package:me_notes/views/login_view.dart';
import 'package:me_notes/views/notes_view.dart';
import 'package:me_notes/views/register_view.dart';
import 'package:me_notes/views/verify_email_view.dart';
import 'package:me_notes/constants/routes.dart';



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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegsiterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    )
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Register Email and Password Felid
    return FutureBuilder(  // Future builder so Firebase init happens before everything else
      future: AuthService.firebase().initialize(),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
          final user = AuthService.firebase().currentUser;

          if (user != null) {
            if (user.isEmailVerified == true) {
              return const NotesView();  // Take this out and send else where

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

