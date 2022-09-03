import 'dart:developer';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:hospitals/src/server_interceptors.dart';
import 'package:hospitals/src/server.dart';
import 'package:hospitals/src/utils.dart';
import 'package:logging/logging.dart';

void main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    log(
      '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}',
    );
  });

  var port = Platform.environment['PORT'];
  if (port == null) {
    throw Exception('Port variable is not defined');
  }

  final intPort = int.parse(port);

  final hospitalsData = await Utils.readHospitalsFromCSV();

  final interceptors = [
    loggingInterceptor,
    authInterceptor,
  ];

  final server = Server(
    [HospitalServer(hospitalData: hospitalsData)],
    interceptors,
  );

  final ip = InternetAddress.anyIPv4;

  await server.serve(port: intPort, address: ip);

  log('Server running at port ${server.port}');
}
