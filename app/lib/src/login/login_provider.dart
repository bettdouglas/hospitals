import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospitals_riverpod/src/firebase_controllers.dart';

import 'package:hospitals_riverpod/src/login/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(
    this.firebaseAuth,
  ) : super(LoginState.initial());

  final FirebaseAuth firebaseAuth;

  Future<void> login(String email, String password) async {
    state = LoginState.loading('Checking supplied email and password');
    try {
      final userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = LoginState.loggedIn(userCred.user!);
    } on FirebaseAuthException catch (e, st) {
      state = LoginState.failure(e.message!, st);
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref.read(firebaseAuthProvider));
});
