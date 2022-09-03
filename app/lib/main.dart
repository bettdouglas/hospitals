import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospitals_riverpod/src/all_hospitals.dart';
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
  @override
  Widget build(BuildContext context) {
    final colorScheme = randomColorSchemeLight(shouldPrint: false);
    return MaterialApp(
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
      home: FirebaseInitPage(homeWidget: EntryPoint()),
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchHospitalsPage(),
                  ),
                );
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllHospitalsPage(),
                  ),
                );
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RandomNHospitalsPage(),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 20,
                child: Text('Stream Kenyan Hospitals'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
