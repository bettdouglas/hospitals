import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hospitals_riverpod/src/generated/index.dart';

import 'common_widgets.dart';
import 'constants.dart';

final bidiSearchHandlerProvider = Provider(
  (ref) => BidiSearchHandler(stub: ref.read(hostpitalClientProvider)),
);

final hospitalsStreamProvider = StreamProvider(
  (ref) => ref.watch(bidiSearchHandlerProvider).resultStream,
);

class BidiSearchHandler {
  BidiSearchHandler({
    required this.stub,
  }) {
    final searchStream = _controller.stream.asBroadcastStream();
    final s1 = searchStream.listen((event) {
      print('s1. ${event.value}');
    });
    stub.bidiSearch(searchStream).map((e) {
      print(e.hospitals.length);
      return e.hospitals;
    }).pipe(_resultController);
  }
  // our grpc stub
  final HospitalServerClient stub;

  final _controller = StreamController<SearchQuery>();
  final _resultController = StreamController<List<Hospital>>()..add([]);
  Stream<List<Hospital>> get resultStream => _resultController.stream;

  // we add the typed values here using TextField onChanged
  void add(String keyword) async {
    _controller.add(SearchQuery(value: keyword));
  }
}

class BidiSearchHospitalsWidget extends ConsumerWidget {
  final ted = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProvider = ref.watch(bidiSearchHandlerProvider);
    final resultState = ref.watch(hospitalsStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            // here we listen to keyboard changes via onChanged method
            // and add the words being typed into our streamController
            onChanged: (str) => searchProvider.add(str),
            autofocus: true,
            controller: ted,
            decoration: InputDecoration(
              suffix: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  resultState.when(
                    data: (d) => d.length.toString(),
                    loading: () => '...',
                    error: (_, __) => '!',
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: resultState.when(
              data: (hospitals) => HospitalsListView(hospitals: hospitals),
              loading: () => LoadingView(msg: 'Searching for ${ted.text}'),
              error: (error, _) => ErrorView(
                error: error,
                msg: 'Error when searching for hospitals',
                retryFunction: () => searchProvider.add(ted.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BidiSearchHospitalsPage extends StatelessWidget {
  const BidiSearchHospitalsPage({Key? key}) : super(key: key);

  static String get route => '/bidi-search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Kenyan Hospitals'),
      ),
      body: BidiSearchHospitalsWidget(),
    );
  }
}
