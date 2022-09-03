import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospitals_riverpod/firebase_options.dart';

final firebaseInitProvider = FutureProvider(
  (ref) => Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ),
);

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

final uidProvider = Provider<String?>((ref) {});

class FirebaseInitPage extends ConsumerWidget {
  const FirebaseInitPage({
    required this.homeWidget,
    Key? key,
  }) : super(key: key);

  final Widget homeWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(firebaseInitProvider);
    return state.when(
      data: (_) => homeWidget,
      error: (err, st) => Scaffold(
        appBar: AppBar(
          title: Text('Firebase Init Error'),
        ),
        body: Column(
          children: [
            Text(err.toString()),
            SizedBox(height: 40),
            Text(st.toString()),
            ElevatedButton.icon(
              onPressed: () {
                ref.refresh(firebaseInitProvider);
              },
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text('Loading'),
        ),
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

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
