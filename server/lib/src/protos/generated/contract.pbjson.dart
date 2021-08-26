///
//  Generated code. Do not modify.
//  source: lib/src/protos/contract.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use hospitalDescriptor instead')
const Hospital$json = const {
  '1': 'Hospital',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'coordinate', '3': 2, '4': 1, '5': 11, '6': '.Location', '10': 'coordinate'},
    const {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'location', '3': 4, '4': 1, '5': 9, '10': 'location'},
  ],
};

/// Descriptor for `Hospital`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hospitalDescriptor = $convert.base64Decode('CghIb3NwaXRhbBISCgRuYW1lGAEgASgJUgRuYW1lEikKCmNvb3JkaW5hdGUYAiABKAsyCS5Mb2NhdGlvblIKY29vcmRpbmF0ZRISCgR0eXBlGAMgASgJUgR0eXBlEhoKCGxvY2F0aW9uGAQgASgJUghsb2NhdGlvbg==');
@$core.Deprecated('Use hospitalsDescriptor instead')
const Hospitals$json = const {
  '1': 'Hospitals',
  '2': const [
    const {'1': 'hospitals', '3': 1, '4': 3, '5': 11, '6': '.Hospital', '10': 'hospitals'},
  ],
};

/// Descriptor for `Hospitals`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hospitalsDescriptor = $convert.base64Decode('CglIb3NwaXRhbHMSJwoJaG9zcGl0YWxzGAEgAygLMgkuSG9zcGl0YWxSCWhvc3BpdGFscw==');
@$core.Deprecated('Use searchQueryDescriptor instead')
const SearchQuery$json = const {
  '1': 'SearchQuery',
  '2': const [
    const {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `SearchQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchQueryDescriptor = $convert.base64Decode('CgtTZWFyY2hRdWVyeRIUCgV2YWx1ZRgBIAEoCVIFdmFsdWU=');
@$core.Deprecated('Use locationDescriptor instead')
const Location$json = const {
  '1': 'Location',
  '2': const [
    const {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    const {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `Location`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationDescriptor = $convert.base64Decode('CghMb2NhdGlvbhIaCghsYXRpdHVkZRgBIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgASgBUglsb25naXR1ZGU=');
