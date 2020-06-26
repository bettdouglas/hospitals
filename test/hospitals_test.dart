import 'package:hospitals/hospitals.dart';
import 'package:hospitals/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('Read CSV Hospital Rows', () async {
    List<HospitalData> hospitals = await Utils.readHospitalsFromCSV();
    // expect(hospitals.first, HospitalData('KATHOME MEDICAL CLINIC','PRIV',37.364157,-1.377716));
  });
}
