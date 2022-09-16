import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hospitals_riverpod/main.dart';
import 'package:hospitals_riverpod/src/all_hospitals.dart';
import 'package:hospitals_riverpod/src/auth/auth_state_provider.dart';
import 'package:hospitals_riverpod/src/bidi_search_hospitals_page.dart';
import 'package:hospitals_riverpod/src/login/login_page.dart';
import 'package:hospitals_riverpod/src/search_hospitals_page.dart';
import 'package:hospitals_riverpod/src/sign_up/sign_up_page.dart';
import 'package:hospitals_riverpod/src/stream_kenyan_hospitals.dart';

final unguardedRoutes = [
  // SignUpPage.route,
  // LoginPage.route,
  '/',
];

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => EntryPoint(),
      ),
      GoRoute(
        path: SearchHospitalsPage.route,
        builder: (context, state) => SearchHospitalsPage(),
      ),
      GoRoute(
        path: AllHospitalsPage.route,
        builder: (context, state) => AllHospitalsPage(),
      ),
      GoRoute(
        path: RandomNHospitalsPage.route,
        builder: (context, state) => RandomNHospitalsPage(),
      ),
      GoRoute(
        path: BidiSearchHospitalsPage.route,
        builder: (context, state) => BidiSearchHospitalsPage(),
      ),
      GoRoute(
        path: SignUpPage.route,
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: LoginPage.route,
        builder: (context, state) => LoginPage(),
      ),
    ],
    refreshListenable: AuthStateListenable(ref: ref),
    redirect: (state) {
      final authState = ref.read(authProvider);
      final location = state.location;

      final purePath = location.split('?from=').first;

      final loggingIn = purePath == LoginPage.route;
      final signingUp = purePath == SignUpPage.route;
      if (unguardedRoutes.contains(location)) {
        return null;
      }

      return authState.maybeWhen(
        orElse: () {
          // if coming from login to signup
          // if(signingUp && )
          if (loggingIn || signingUp) {
            // no need to redirect.
            return null;
          } else {
            final fromP = state.subloc == '/' ? '' : '?from=${state.subloc}';
            ref.read(postLoginRedirectProvider.notifier).change(state.subloc);
            return '${LoginPage.route}$fromP';
          }
        },
        authenticated: (user) {
          if (loggingIn || signingUp) {
            // go to homePage if user is on login-page
            return ref.read(postLoginRedirectProvider);
          } else {
            return null;
          }
        },
      );
    },
  );
});

class RedirectPathProvider extends StateNotifier<String> {
  RedirectPathProvider() : super('/');

  void change(String text) => state = text;
}

final postLoginRedirectProvider =
    StateNotifierProvider<RedirectPathProvider, String>(
  (ref) => RedirectPathProvider(),
);
