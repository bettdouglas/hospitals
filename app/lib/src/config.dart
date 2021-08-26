import 'package:flutter_riverpod/flutter_riverpod.dart';

class Config {
  final String host;
  final int port;
  Config({
    required this.host,
    required this.port,
  });

  Config copyWith({
    String? host,
    int? port,
  }) {
    return Config(
      host: host ?? this.host,
      port: port ?? this.port,
    );
  }
}

final configFutureProvider = FutureProvider<Config>(
  (ref) async {
    await Future.delayed(Duration(seconds: 1));
    return Config(host: 'localhost', port: 8080);
  },
);
