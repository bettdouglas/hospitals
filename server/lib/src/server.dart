import 'dart:math';

import 'package:grpc/grpc.dart';
import 'package:grpc/src/server/call.dart';
import 'package:hospitals/src/extensions.dart';
import 'package:hospitals/src/protos/generated/contract.pbgrpc.dart';
import 'package:hospitals/src/utils.dart';

class HospitalServer extends HospitalServerServiceBase {
  // start server after successfully reading list of hospitals
  final List<HospitalData> hospitalData;
  late List<Hospital> _hospitals;

  HospitalServer({required this.hospitalData}) {
    _hospitals = hospitalData.map((hd) {
      final coordinate = Location(
        latitude: hd.latitude,
        longitude: hd.longitude,
      );
      return Hospital(
        name: hd.name.capitalizeFirstofEach,
        location: hd.location,
        coordinate: coordinate,
        type: hd.type,
      );
    }).toList();
  }

  @override
  Future<Hospitals> getHospitals(ServiceCall call, Empty request) async {
    return Hospitals(hospitals: _hospitals);
  }

  @override
  Future<Hospitals> searchHospitals(
    ServiceCall call,
    SearchQuery request,
  ) async {
    final searchTerm = request.value;
    final filtered = _hospitals.where(
      (hospital) => hospital.name.toLowerCase().contains(
            searchTerm.toLowerCase(),
          ),
    );
    return Hospitals(
      hospitals: filtered,
    );
  }

  @override
  Stream<StreamNRandomHospitalsResponse> streamNRandomHospitals(
    ServiceCall call,
    StreamNRandomHospitalsRequest request,
  ) async* {
    final count = request.count;
    print(count);
    final stream = Stream.periodic(Duration(seconds: 5)).map(
      (event) => StreamNRandomHospitalsResponse(
        hospitals: _hospitals.randomN(count),
      ),
    );
    print(stream);
    yield* stream;
  }

  @override
  Future<NearestHospitalsResponse> nearestHospitals(
    ServiceCall call,
    NearestHospitalsRequest request,
  ) {
    // TODO: implement nearestHospitals
    throw UnimplementedError();
  }
}

extension RandomN<T> on List<T> {
  T get random {
    return elementAt(Random().nextInt(length));
  }

  List<T> randomN(int count) {
    final elements = <T>{};
    while (elements.length < count) {
      elements.add(random);
    }
    return elements.toList();
  }
}
