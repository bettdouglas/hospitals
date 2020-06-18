import 'package:grpc/src/server/call.dart';
import 'package:hospitals/src/protos/generated/contract.pbgrpc.dart';
import 'package:hospitals/src/utils.dart';

class HospitalServer extends HospitalServerServiceBase {

  // start server after successfully reading list of hospitals
  final List<HospitalData> hospitalData;
  List<Hospital> _hospitals;

  HospitalServer(this.hospitalData) {
    _hospitals = hospitalData.map((hd) {
      final coordinate = Location()..latitude = hd.latitude
                                   ..longitude = hd.longitude;
      return Hospital()..name = hd.name
                       ..location = hd.location
                       ..coordinate = coordinate
                       ..type = hd.type;
    });
  }

  @override
  Future<Hospitals> getHospitals(ServiceCall call, Empty request) async {
    return Hospitals()..hospitals.addAll(_hospitals);
  }

  @override
  Future<Hospitals> searchHospitals(ServiceCall call, SearchQuery request) async {
    final searchTerm = request.value;
    final filtered = _hospitals.where((hospital) => hospital.name.contains(searchTerm));
    return Hospitals()..hospitals.addAll(filtered);
  }
  
}