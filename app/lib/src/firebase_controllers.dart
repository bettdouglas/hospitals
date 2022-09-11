import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final userProvider = Provider<User?>((ref) {
  // just reload when user changes
  final _ = ref.watch(userStreamProvider);
  final user = ref.watch(firebaseAuthProvider).currentUser;
  return user;
});

final userStreamProvider = StreamProvider(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

class LoginLogoutIcon extends ConsumerWidget {
  const LoginLogoutIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamState = ref.watch(userStreamProvider);
    return streamState.when(
      data: (user) {
        if (user == null) {
          return IconButton(
            onPressed: () {
              ref.read(firebaseAuthProvider).signInAnonymously();
            },
            icon: Icon(Icons.account_circle),
          );
        } else {
          return IconButton(
            onPressed: () {
              ref.read(firebaseAuthProvider).signOut();
            },
            icon: Icon(Icons.exit_to_app),
          );
        }
      },
      error: (er, _) => IconButton(
        onPressed: () {},
        icon: Icon(Icons.error),
      ),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
