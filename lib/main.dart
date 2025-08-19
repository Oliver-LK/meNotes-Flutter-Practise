import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:me_notes/views/login_view.dart';
import 'package:me_notes/views/register_view.dart';
import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
  MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    )
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),

      // Register Email and Password Feild
      body: FutureBuilder(  // Future builder so Firebase init happens before everything else
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user?.emailVerified ?? false == true) {
              print('You are verified');
            } else {
              print('You are not verified');
            }
            return const Text('Done');

          default:
            return  const Text('Something may be wrong...');
        
          }
        }
      ),
    );
  }
}