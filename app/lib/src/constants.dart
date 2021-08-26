import 'package:grpc/grpc.dart';
import 'package:hospitals_riverpod/src/generated/index.dart';

final _channelOptions = ChannelOptions(
  credentials: ChannelCredentials.secure(), // transmit unencrypted data.,
);

final _channel = ClientChannel(
  'hospitals-dart-grpc-fysuv2s5na-ez.a.run.app', // connect to localhost. Where it's served.
  options: _channelOptions, // pass the channelOptions above.
);
final hospitalClient = HospitalServerClient(_channel);
