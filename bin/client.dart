import 'package:grpc/grpc.dart';
import 'package:hospitals/src/protos/generated/contract.pbgrpc.dart';
// import 'package:riverpod/riverpod.dart';

// class TestInterceptor extends ClientInterceptor {
//   void run() {}

//   @override
//   ResponseFuture<R> interceptUnary<Q, R>(
//     ClientMethod<Q, R> method,
//     Q request,
//     CallOptions options,
//     invoker,
//   ) {
//     print(request);
//     print(method.path);
//     return super.interceptUnary(method, request, options, invoker);
//   }
// }

void main(List<String> args) async {
  final channelOptions = ChannelOptions(
    credentials: ChannelCredentials.secure(), // transmit unencrypted data.,
  );

  final channel = ClientChannel(
    'hospitals-dart-grpc-fysuv2s5na-ez.a.run.app', // connect to localhost. Where it's served.
    options: channelOptions, // pass the channelOptions above.
  );

  final client = HospitalServerClient(
    channel,
    interceptors: [],
  ); // this handles communication to the server
  final allHospitals = await client.getHospitals(Empty());
  print(allHospitals.hospitals);
  await channel.terminate();
}
  // communicate with server like

//   final sa = SearchAhead(client);

//   sa.addListener((state) {
//     print(state);
//   });

//   while (true) {
//     final typedLine = stdin.readLineSync();
//     sa.add(typedLine);
//   }
// }

// class SearchAhead extends StateNotifier<List<Hospital>> {
//   final HospitalServerClient stub;

//   SearchAhead(this.stub) : super([]) {
//     _controller.stream.asyncMap(_searchHospital).listen((event) {
//       state = event.hospitals;
//     });
//   }

//   final _controller = StreamController<String>();

//   Future<Hospitals> _searchHospital(String query) async {
//     print('Searching for $query');
//     final response = await stub.searchHospitals(
//       SearchQuery(
//         value: query,
//       ),
//     );
//     return response;
//   }

//   void add(String? keyword) async {
//     print('added $keyword');
//     _controller.add(keyword!);
//   }
// }
