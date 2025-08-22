
import 'package:me_notes/services/auth/auth_provider.dart';
import 'package:me_notes/services/auth/auth_user.dart';
import 'package:me_notes/services/auth/firebase_auth_provider.dart';


class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider(),);

  @override
  Future<void> initialize() => provider.initialize();
  
  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password
    }) => createUser(email: email, password: password);
  
  @override
  
  AuthUser? get currentUser => provider.currentUser;
  
  @override
  Future<AuthUser> logIn({
    required String email, 
    required String password
    }) => logIn(email: email, password: password);
  
  @override
  Future<void> logOut() => logOut();
  
  @override
  Future<void> sendEmailVerification() => sendEmailVerification();
  
}