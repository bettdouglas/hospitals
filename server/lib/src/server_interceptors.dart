import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:hospitals/src/id_token_verifier.dart';

Future<GrpcError?> authInterceptor(
  ServiceCall call,
  ServiceMethod method,
) async {
  final metadata = call.clientMetadata ?? {};
  final idToken = metadata['token'];
  print(metadata['count']);
  if (idToken == null) {
    return GrpcError.unauthenticated('Missing Auth Token');
  }
  final response = await tokenVerifier.verifyToken(idToken);
  return response.fold(
    (l) => GrpcError.unauthenticated(l),
    (claims) {
      metadata['user_id'] = claims['user_id'];
      return;
    },
  );
}

Future<GrpcError?> loggingInterceptor(
  ServiceCall call,
  ServiceMethod method,
) async {
  print(method.name);
  return null;
}

final tokenVerifier = FirebaseTokenVerifier();
