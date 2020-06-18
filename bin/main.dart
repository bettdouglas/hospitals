import 'package:grpc/grpc.dart';
import 'package:hospitals/src/server.dart';
import 'package:hospitals/src/utils.dart';

void main(List<String> arguments) async {
  final hospitalsData = await Utils.readHospitalsFromCSV();

  final server = Server([
    HospitalServer(
      hospitalsData,
    )
  ]);

  await server.serve(address: 'localhost', port: 12345);
}
