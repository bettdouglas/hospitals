import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hospitals_riverpod/src/all_hospitals.dart';
import 'package:hospitals_riverpod/src/bidi_search_hospitals_page.dart';
import 'package:hospitals_riverpod/src/firebase_controllers.dart';
import 'package:hospitals_riverpod/src/search_hospitals_page.dart';
import 'package:hospitals_riverpod/src/stream_kenyan_hospitals.dart';
import 'package:logging/logging.dart';
import 'package:random_color_scheme/random_color_scheme.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    log(
      '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}',
    );
  });

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => FirebaseInitPage(homeWidget: EntryPoint()),
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
      )
    ],
    redirect: (state) {},
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = randomColorSchemeLight(shouldPrint: false);
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
      title: 'Flutter/Dart gRPC Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          color: colorScheme.primary,
          actionsIconTheme: IconThemeData(
            color: colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('gRPC Riverpod Example'),
        centerTitle: true,
        actions: [
          LoginLogoutIcon(),
        ],
        actionsIconTheme: Theme.of(context).primaryIconTheme,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.go(SearchHospitalsPage.route);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  child: Text('Search kenyan hospitals'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go(AllHospitalsPage.route);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  child: Text('All kenyan hospitals'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go(RandomNHospitalsPage.route);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  child: Text('Server Streaming Search'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go(BidiSearchHospitalsPage.route);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  child: Text('BidiRectional Search'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
