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

  List<Hospital> _searchByName(String name) {
    return _hospitals
        .where(
          (hospital) => hospital.name.toLowerCase().contains(
                name.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Future<Hospitals> searchHospitals(
    ServiceCall call,
    SearchQuery request,
  ) async {
    final name = request.value;
    final filtered = _searchByName(name);
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
    final stream = Stream.periodic(Duration(seconds: 1)).map(
      (event) {
        print(event);
        return StreamNRandomHospitalsResponse(
          hospitals: _hospitals.randomN(count),
        );
      },
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

  @override
  Stream<Hospitals> bidiSearch(
    ServiceCall call,
    Stream<SearchQuery> request,
  ) async* {
    // debounce streams t
    await for (final query in request) {
      print(query);
      final filtered = _searchByName(query.value);
      yield Hospitals(hospitals: filtered);
    }
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
