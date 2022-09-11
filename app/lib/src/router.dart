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
  LoginPage.route,
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
      final userIsLoggingIn = location == LoginPage.route;
      

      return authState.maybeWhen(
        orElse: () {
          if (userIsLoggingIn) {
            return null;
          }
          return LoginPage.route;
        },
        unAuthenticated: () {
          if (unguardedRoutes.contains(location)) {
            return null;
          }
          return;
        },
        authenticated: (user) {
          if (userIsLoggingIn) {
            // go to homePage if user is on login-page
            return '/';
          } else if (location == SignUpPage.route) {
            return '/';
          } else {
            return null;
          }
        },
      );
    },
  );
});
