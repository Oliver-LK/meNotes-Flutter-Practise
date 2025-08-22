import 'package:me_notes/firebase_options.dart';
import 'package:me_notes/services/auth/auth_provider.dart';
import 'package:me_notes/services/auth/auth_user.dart';
import 'package:me_notes/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException, FirebaseException, User, instanceFor;
import 'package:firebase_core/firebase_core.dart';

import 'dart:developer' as devtools show log;

class FirebaseAuthProvider implements AuthProvider {

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, 
          password: password,
        );

        final user = currentUser;
        if (user != null) {
          return user;
        } else {
          throw UserNotLoggedInAuthException();
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          devtools.log("Password must be at least 6 characters");
          throw WeakPasswordAuthException();

        } else if(e.code == 'email-already-in-use') {
          devtools.log("Email already in use");
          throw EmailAlreadyInUseAuthException();

        } else if (e.code == 'invalid-email') {
          devtools.log('Invalid Email');
          throw InvalidEmailAuthException();

        } else if (e.code == 'channel-error') {
          devtools.log("Email and password felids have been left blank");
          throw ChannelErrorAuthException();

        } else {
          devtools.log('Firebase exception not handled');
          throw GenericsAuthException();
        }

      } catch (_) {
        devtools.log('Another exception not handled');
        throw GenericsAuthException();
      }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
       
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email, 
    required String password
    }) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, 
          password: password
        );

        final user = currentUser;
        if (user != null) {
          return user;

        } else {
          throw UserNotLoggedInAuthException();
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
      
        } else if (e.code == 'wrong-password') {
          devtools.log(e.toString());
          throw WrongPasswordAuthException();

        } else if (e.code == 'channel-error') {
          devtools.log(e.toString());
          throw ChannelErrorAuthException();

        } else if (e.code == 'invalid-email') {
          devtools.log(e.toString());
          throw InvalidEmailAuthException();

        } else {
          devtools.log("Unhandled Auth Error");
          devtools.log(e.toString());
          throw GenericsAuthException();
        } 

      } catch (e) {
        devtools.log("Something else Happened");
        devtools.log(e.toString());
        throw GenericsAuthException();
      }

    throw GenericsAuthException();  // TO DO: Maybe consider adding something else here
   }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
  
  
  
}

 