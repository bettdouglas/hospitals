import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:grpc/grpc.dart';
import 'package:hospitals/src/id_token_verifier.dart';
import 'package:logging/logging.dart';

Future<GrpcError?> authInterceptor(
  ServiceCall call,
  ServiceMethod method,
) async {
  final metadata = call.clientMetadata ?? {};
  final idToken = metadata['token'];
  if (idToken == null) {
    return GrpcError.unauthenticated('Missing Auth Token');
  }
  final response = await verifyToken(idToken);
  return response.fold(
    (l) => GrpcError.unauthenticated(l),
    (claims) {
      metadata['user_id'] = claims['user_id'];
      return;
    },
  );
}

Future<Either<String, Map<String, dynamic>>> verifyToken(
  String idToken,
) async {
  // ...
  //  returns claims if token
  return tokenVerifier.verifyToken(idToken);
}

Future<GrpcError?> loggingInterceptor(
  ServiceCall call,
  ServiceMethod method,
) async {
  final dateTime = DateTime.now();
  final clientMetadata = call.clientMetadata ?? {};
  final authority = clientMetadata[':authority'];
  final methodName = clientMetadata[':path'];
  final method = clientMetadata[':method'];
  final userAgent = clientMetadata['user-agent'];

  logger.info('$authority - - [$dateTime] $method $methodName $userAgent');
  return null;
}

final logger = Logger('LoggingInterceptor');
final tokenVerifier = FirebaseTokenVerifier();
