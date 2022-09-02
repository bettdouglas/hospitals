import 'package:dart_jts/dart_jts.dart';
import 'package:dartz/dartz.dart';

import 'package:hospitals/src/domain.dart';

class HospitalsRepository {
  final List<Hospital> hospitalList;
  HospitalsRepository({
    required this.hospitalList,
  }) {
    final db = STRtree();
    hospitalList.forEach((hospital) {
      final envelope = _gf
          .createPoint(Coordinate(hospital.location.lon, hospital.location.lat))
          .envelope!;
      db.insert(envelope, hospital);
    });
    _database = Some(db);
  }

  Option<STRtree> _database = None();
  final _gf = GeometryFactory.defaultPrecision();

  Future<Either<Exception, List<Hospital>>> allHospitals() async {
    return _database.toEither(() => Exception('Database is not ready')).map(
      (r) {
        return r.itemsTree() as List<Hospital>;
      },
    );
  }

  Future<Either<Exception, List<Hospital>>> searchHospitals(String name) async {
    return _database.toEither(() => Exception('Database is not ready')).map(
      (r) {
        return (r.itemsTree() as List<Hospital>)
            .where((e) => e.name.contains(name))
            .toList();
      },
    );
  }

  Future<Either<Exception, List<Hospital>>> nearestHospitals(
    LatLng latLng,
    int page,
    int count,
  ) async {
    // return _database.toEither(() => Exception('Database is not ready')).map(
    //   (r) {
    //     final one = Boundable();
    //     return r.nearestNeighbourK(BoundablePair(boundable1, boundable2, itemDistance), k)
    //   },
    // );
    throw UnimplementedError();
  }
}

extension AsCoordinate on LatLng {
  Point asPoint(GeometryFactory gf) {
    return gf.createPoint(Coordinate(lon, lat));
  }
}

// class MockHospitalsRepository implements HospitalsRepository {
//   @override
//   Future<Either<Exception, List<String>>> allHospitals() {
//     // TODO: implement allHospitals
//     throw UnimplementedError();
//   }

//   @override
//   // TODO: implement hospitalList
//   List<Hospital> get hospitalList => throw UnimplementedError();

//   @override
//   Future<Either<Exception, List<String>>> nearestHospitals() {
//     // TODO: implement nearestHospitals
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either<Exception, List<String>>> searchHospitals(String name) {
//     // TODO: implement searchHospitals
//     throw UnimplementedError();
//   }
// }

// class TypedSTRTree<Type> {}
