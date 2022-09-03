import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';
import 'package:hospitals_riverpod/src/firebase_controllers.dart';

import 'package:hospitals_riverpod/src/generated/index.dart';
import 'package:hospitals_riverpod/src/interceptors/inject_firebase_token_interceptor.dart';
import 'package:hospitals_riverpod/src/interceptors/logging_interceptor.dart';

final _channelOptions = ChannelOptions(
  credentials: ChannelCredentials.insecure(), // transmit unencrypted data.,
);

final _channel = ClientChannel(
  '0.0.0.0', // connect to localhost. Where it's served.
  port: 3001,
  options: _channelOptions, // pass the channelOptions above.
);

final hostpitalClientProvider = Provider((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return HospitalServerClient(
    _channel,
    interceptors: [
      // this logs the requests
      RequestLoggingInterceptor(),
      // this injects the firebase token into the request call
      AuthMetadataInterceptor(firebaseAuth: firebaseAuth),
    ],
  );
});
