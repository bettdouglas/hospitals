///
//  Generated code. Do not modify.
//  source: lib/src/protos/contract.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'contract.pb.dart' as $0;
export 'contract.pb.dart';

class HospitalServerClient extends $grpc.Client {
  static final _$getHospitals = $grpc.ClientMethod<$0.Empty, $0.Hospitals>(
      '/HospitalServer/GetHospitals',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Hospitals.fromBuffer(value));
  static final _$searchHospitals =
      $grpc.ClientMethod<$0.SearchQuery, $0.Hospitals>(
          '/HospitalServer/SearchHospitals',
          ($0.SearchQuery value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Hospitals.fromBuffer(value));

  HospitalServerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Hospitals> getHospitals($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getHospitals, request, options: options);
  }

  $grpc.ResponseFuture<$0.Hospitals> searchHospitals($0.SearchQuery request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$searchHospitals, request, options: options);
  }
}

abstract class HospitalServerServiceBase extends $grpc.Service {
  $core.String get $name => 'HospitalServer';

  HospitalServerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Hospitals>(
        'GetHospitals',
        getHospitals_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Hospitals value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SearchQuery, $0.Hospitals>(
        'SearchHospitals',
        searchHospitals_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SearchQuery.fromBuffer(value),
        ($0.Hospitals value) => value.writeToBuffer()));
  }

  $async.Future<$0.Hospitals> getHospitals_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getHospitals(call, await request);
  }

  $async.Future<$0.Hospitals> searchHospitals_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SearchQuery> request) async {
    return searchHospitals(call, await request);
  }

  $async.Future<$0.Hospitals> getHospitals(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Hospitals> searchHospitals(
      $grpc.ServiceCall call, $0.SearchQuery request);
}
