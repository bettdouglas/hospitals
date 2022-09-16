import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospitals_riverpod/src/firebase_controllers.dart';

import 'package:hospitals_riverpod/src/generated/index.dart';
import 'package:hospitals_riverpod/src/interceptors/inject_firebase_token_interceptor.dart';
import 'package:hospitals_riverpod/src/interceptors/logging_interceptor.dart';
import 'package:build_grpc_channel/build_grpc_channel.dart';

final host = 'http://localhost';
final port = 8080;

final _channel = buildGrpcChannel(host: host, port: port, secure: false);

/// 1. Change to port 443
/// 2. Host make is https
/// 3. secure should be true

final hostpitalClientProvider = Provider((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final channel = _channel;

  return HospitalServerClient(
    channel,
    interceptors: [
      // this logs the requests
      RequestLoggingInterceptor(),
      // this injects the firebase token into the request call
      AuthMetadataInterceptor(firebaseAuth: firebaseAuth),
    ],
  );
});
