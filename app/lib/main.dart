import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:hospitals_riverpod/firebase_options.dart';
import 'package:hospitals_riverpod/src/all_hospitals.dart';
import 'package:hospitals_riverpod/src/router.dart';
import 'package:hospitals_riverpod/src/sign_up/sign_up_page.dart';
import 'package:hospitals_riverpod/src/bidi_search_hospitals_page.dart';
import 'package:hospitals_riverpod/src/firebase_controllers.dart';
import 'package:hospitals_riverpod/src/search_hospitals_page.dart';
import 'package:hospitals_riverpod/src/stream_kenyan_hospitals.dart';
import 'package:logging/logging.dart';
import 'package:random_color_scheme/random_color_scheme.dart';

class LoggingObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final logger = Logger(provider.runtimeType.toString());
    logger.info('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    log(
      '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}',
    );
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.read(routerProvider);
    final colorScheme = randomColorSchemeLight(shouldPrint: false);
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
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
      supportedLocales: [
        Locale('en'),
      ],
      localizationsDelegates: [
        FormBuilderLocalizations.delegate,
      ],
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
                  context.push(SearchHospitalsPage.route);
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
                  context.push(AllHospitalsPage.route);
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
                  context.push(RandomNHospitalsPage.route);
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
                  context.push(BidiSearchHospitalsPage.route);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  child: Text('BidiRectional Search'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go(SignUpPage.route);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  child: Text('SignUp'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
