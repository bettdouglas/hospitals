import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';

class Utils {
  static Future<List<HospitalData>> readHospitalsFromCSV() async {
    var healthCSV = File('assets/health.csv');
    var csvString = await healthCSV.readAsString();
    var d = FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);

    var csvRows =
        CsvToListConverter().convert(csvString, csvSettingsDetector: d);
    return csvRows
        .map((e) =>
            HospitalData(e[2], e[5], e[1].toDouble(), e[0].toDouble(), e[3]))
        .toList();
  }
}

class HospitalData {
  final String name, type, location;
  final double latitude, longitude;

  HospitalData(
      this.name, this.type, this.latitude, this.longitude, this.location);
}
