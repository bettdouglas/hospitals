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
      print(purePath);

      print(location);
      final loggingIn = purePath == LoginPage.route;
      final signingUp = purePath == SignUpPage.route;
      print('IsLoggingIn: $loggingIn');
      print('Subloc: ${state.subloc}');
      if (unguardedRoutes.contains(location)) {
        return null;
      }

      print(state.queryParametersAll);

      // We need to maintain the fromP if it already existed
      late String fromP;
      if (state.queryParams.containsKey('from')) {
        fromP = state.queryParams['from']!;
      } else {
        fromP = state.subloc == '/' ? '' : '?from=${state.subloc}';
      }

      return authState.maybeWhen(
        orElse: () {
          // if coming from login to signup
          // if(signingUp && )
          if (loggingIn || signingUp) {
            // no need to redirect.
            return null;
          } else {
            return '${LoginPage.route}$fromP';
          }
        },
        authenticated: (user) {
          if (loggingIn) {
            // go to homePage if user is on login-page
            return fromP;
          } else if (signingUp) {
            return '/';
          } else {
            return null;
          }
        },
      );
    },
  );
});
