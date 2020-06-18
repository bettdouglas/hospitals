import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';

class Utils {
  static Future<List<dynamic>> readHospitalsFromCSV() async {
    var healthCSV = File('lib/assets/health.csv');
    var csvString = await healthCSV.readAsString();
    var d = FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);

    var csvRows = CsvToListConverter().convert(csvString,csvSettingsDetector: d);
    return csvRows.map((e) => HospitalData(e[2], e[5], e[1].toDouble(), e[0].toDouble())).toList();
  }
}

class HospitalData {
  final String name,type;
  final double latitude,longitude;

  HospitalData(this.name, this.type, this.latitude, this.longitude);
}