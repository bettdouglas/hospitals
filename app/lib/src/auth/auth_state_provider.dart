import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hospitals_riverpod/src/auth/auth_state.dart';
import 'package:hospitals_riverpod/src/firebase_controllers.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier({
    required this.firebaseAuth,
  }) : super(AuthState.initial()) {
    state = AuthState.loading('Listening to user stream');
    streamSubscription = firebaseAuth.authStateChanges().listen(
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = AuthState.unAuthenticated();
        }
      },
      onError: (err, st) {
        state = AuthState.failure(
          'Something went wrong when listening to auth state changes.',
          st,
        );
      },
    );
  }

  final FirebaseAuth firebaseAuth;

  late StreamSubscription streamSubscription;

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
}

/// GoRouter Listenable needs an instance of changenotifier
class AuthStateListenable extends ChangeNotifier {
  final Ref ref;
  AuthStateListenable({
    required this.ref,
  }) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(firebaseAuth: ref.read(firebaseAuthProvider));
});
