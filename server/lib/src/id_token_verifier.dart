import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:convert/convert.dart' show hex;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as jwt;
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

class FirebaseTokenVerifier {
  KeyIdResponse? idKeys;

  Future<Either<String, Map<String, dynamic>>> verifyToken(
      String idToken) async {
    if (idKeys == null) {
      return getKeyIds().then((value) {
        idKeys = value;
      }).then((_) => verifyToken(idToken));
    } else {
      final expiry = idKeys!.expiry;
      final isExpired = DateTime.now().isAfter(expiry);
      if (isExpired) {
        idKeys = null;
        return verifyToken(idToken);
      }

      Error? error;
      Map<String, dynamic>? payload;

      for (var entry in idKeys!.keys.entries) {
        final publicKey = getPublicKeyFromCertificate(entry.value);
        try {
          final claims = jwt.JWT.verify(idToken, jwt.RSAPublicKey(publicKey));
          payload = claims.payload as Map<String, dynamic>;
        } on jwt.JWTExpiredError {
          return Left('Token Expired');
        } on jwt.JWTUndefinedError catch (e) {
          if (e.error is jwt.JWTExpiredError) {
            return Left('Token Expired');
          } else {
            error = e.error;
          }
        }
      }
      if (payload == null) {
        throw Exception(error);
      } else {
        return Right(payload);
      }
    }
  }

  Future<KeyIdResponse> getKeyIds() async {
    final uri = '''
https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com''';
    final response = await get(Uri.parse(uri));
    final cacheControl = response.headers['cache-control']!;
    print(cacheControl);
    final maxAge = cacheControl.replaceAll('public, ', '').split(',').first;
    final expiryInSeconds = int.parse(maxAge.replaceAll('max-age=', ''));
    final keys = (jsonDecode(response.body) as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as String));
    return KeyIdResponse(
      expiry: DateTime.now().add(Duration(seconds: expiryInSeconds)),
      keys: keys,
    );
  }

  Future<List<Map<String, dynamic>>> getJwkKeys() async {
    final uri =
        "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com";
    final response = await get(Uri.parse(uri));
    final cacheControl = response.headers['cache-control']!;
    final maxAge = cacheControl.replaceAll('public, ', '').split(',').first;
    print(maxAge);
    final expiryInSeconds = int.parse(maxAge.replaceAll('max-age=', ''));
    final keys = (jsonDecode(response.body) as Map<String, dynamic>)['keys']
        as List<dynamic>;

    return keys.map((e) => e as Map<String, dynamic>).toList();
  }

  String getPublicKeyFromCertificate(String cert) {
    final parsed = X509Utils.x509CertificateFromPem(cert);
    final bytes = hex.decode(
      parsed.tbsCertificate.subjectPublicKeyInfo.bytes!,
    );
    final key = CryptoUtils.rsaPublicKeyFromDERBytes(
      Uint8List.fromList(bytes),
    );
    return CryptoUtils.encodeRSAPublicKeyToPemPkcs1(key);
  }
}

class KeyIdResponse {
  final DateTime expiry;
  final Map<String, String> keys;
  KeyIdResponse({
    required this.expiry,
    required this.keys,
  });
}
