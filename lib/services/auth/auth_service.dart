
import 'package:me_notes/services/auth/auth_provider.dart';
import 'package:me_notes/services/auth/auth_user.dart';


class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);
  
  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password
    }) => createUser(email: email, password: password);
  
  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => throw UnimplementedError();
  
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