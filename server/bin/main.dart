import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:hospitals/src/server.dart';
import 'package:hospitals/src/utils.dart';

void main(List<String> arguments) async {
  var port = Platform.environment['PORT'];
  if (port == null) {
    throw Exception('Port variable is not defined');
  }

  final intPort = int.parse(port);

  final hospitalsData = await Utils.readHospitalsFromCSV();

  final server = Server([
    HospitalServer(
      hospitalData: hospitalsData,
    ),
  ]);

  await server.serve(port: intPort);

  print('Server running at port ${server.port}');
}
