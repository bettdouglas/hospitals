import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hospitals_riverpod/src/sign_up/sign_up_state.dart';
import 'package:hospitals_riverpod/src/firebase_controllers.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier({
    required this.firebaseAuth,
  }) : super(SignUpState.initial());

  final FirebaseAuth firebaseAuth;

  Future<void> signUp(String email, String password) async {
    state = SignUpState.loading('Creating account with email $email');
    try {
      final userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCred.user != null) {
        state = SignUpState.signedUp(userCred.user!);
      } else {
        state = SignUpState.failure('User object is null.', StackTrace.empty);
      }
    } catch (e, st) {
      state = SignUpState.failure(e.toString(), st);
    }
  }
}

final signUpProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier(
    firebaseAuth: ref.read(firebaseAuthProvider),
  );
});
