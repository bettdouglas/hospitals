import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospitals_riverpod/src/generated/index.dart';
import 'constants.dart';

final searchAheadProvider = Provider(
  (ref) => SearchAhead(hospitalClient),
);

final hospitalsStreamProvider = StreamProvider(
  (ref) => ref.watch(searchAheadProvider).hospitalsStream,
);

class SearchAhead {
  // our grpc stub
  final HospitalServerClient stub;

  // getter to expose hospitals as a list of hospitals
  Stream<List<Hospital>> get hospitalsStream =>
      _hospitalsStream.map((Hospitals e) => e.hospitals);

  // the text stream controller
  final _controller = StreamController<String>();

  // private variable that holds the state of the transformed stream
  late Stream<Hospitals> _hospitalsStream;

  SearchAhead(this.stub) {
    // transform the textStream to Stream<Hospitals> asyncMap.
    _hospitalsStream = _controller.stream.asyncMap((String query) async {
      print('Searching for $query');
      Hospitals response = await stub.searchHospitals(
        SearchQuery(
          value: query,
        ),
      );
      return response;
    });
  }

  // we add the typed values here using TextField onChanged
  void add(String keyword) async {
    _controller.add(keyword);
  }
}

// class SearchHospitalsWidget extends ConsumerWidget {
//   final ted = TextEditingController();

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final searchProvider = watch(searchAheadProvider);
//     final resultState = watch(hospitalsStreamProvider);

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           TextFormField(
//             // here we listen to keyboard changes via onChanged method
//             // and add the words being typed into our streamController
//             onChanged: (str) => searchProvider.add(str),
//             autofocus: true,
//             controller: ted,
//             decoration: InputDecoration(
//               suffix: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Text(
//                   resultState.when(
//                     data: (d) => d.length.toString(),
//                     loading: () => '...',
//                     error: (_, __) => '!',
//                   ),
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: resultState.when(
//               data: (hospitals) => HospitalsListView(hospitals: hospitals),
//               loading: () => LoadingView(msg: 'Searching for ${ted.text}'),
//               error: (error, _) => ErrorView(
//                 error: error,
//                 msg: 'Error when searching for hospitals',
//                 retryFunction: () => searchProvider.add(ted.text),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SearchHospitalsPage extends StatelessWidget {
  const SearchHospitalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Kenyan Hospitals'),
      ),
      // body: SearchHospitalsWidget(),
    );
  }
}
