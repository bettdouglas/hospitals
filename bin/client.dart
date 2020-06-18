import 'package:grpc/grpc.dart';
import 'package:hospitals/src/protos/generated/contract.pbgrpc.dart';

void main(List<String> args) async {
  final channelOptions = ChannelOptions(
    credentials: ChannelCredentials.insecure(), // transmit unencrypted data.
  );

  final channel = ClientChannel(
    'localhost',  // connect to localhost. Where it's served. 
    port: 12345,  // port to communicate over
    options: channelOptions,  // pass the channelOptions above.
  );

  final client = HospitalServerClient(channel); // this handles communication to the server

  // communicate with server like
  final allHospitals = await client.getHospitals(Empty());

  final searchQuery = SearchQuery()..value = 'MA';

  Hospitals searched = await client.searchHospitals(searchQuery);

  searched.hospitals.forEach(print);

}
