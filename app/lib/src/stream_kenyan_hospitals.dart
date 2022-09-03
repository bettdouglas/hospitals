import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hospitals_riverpod/src/common_widgets.dart';
import 'package:hospitals_riverpod/src/constants.dart';
import 'package:hospitals_riverpod/src/generated/contract.pbgrpc.dart';

class RandomNHospitalsPage extends ConsumerStatefulWidget {
  const RandomNHospitalsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RandomNHospitalsPageState();
}

class _RandomNHospitalsPageState extends ConsumerState<RandomNHospitalsPage> {
  var value = 4.0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(randomHospitalsStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('All Kenyan Hospitals'),
      ),
      body: Column(
        children: [
          Expanded(
            child: state.when(
              // when we get the data
              data: (hospitals) => HospitalsListView(hospitals: hospitals),
              // when we're loading
              loading: () => Center(child: CircularProgressIndicator()),
              // when we have an error
              error: (err, stackTrace) => Column(
                children: [
                  Text(err.toString()),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(streamKenyanHospitalsProvider)
                        .update(value.toInt()),
                    child: Container(height: 20, child: Text('Try Again')),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  divisions: 50,
                  min: 0,
                  max: 50,
                  onChanged: (newValue) {
                    setState(() {
                      value = newValue;
                    });
                  },
                ),
              ),
              IconButton(onPressed: () {
                ref
                        .read(streamKenyanHospitalsProvider)
                        .update(value.toInt());
              }, icon: Icon(Icons.update)),
            ],
          )
        ],
      ),
      // bottomNavigationBar: ,
    );
  }
}

class _StreamKenyanHospitalsHandler {
  _StreamKenyanHospitalsHandler({
    required this.hospitalServerClient,
  });
  final HospitalServerClient hospitalServerClient;

  var randomHospitalsStream = Stream<List<Hospital>>.empty();

  void update(int count) async {
    final response = hospitalServerClient.streamNRandomHospitals(
      StreamNRandomHospitalsRequest(count: count),
    );
    randomHospitalsStream = response.map((event) => event.hospitals);
  }
}

final randomHospitalsStreamProvider = StreamProvider<List<Hospital>>((ref) {
  return ref.read(streamKenyanHospitalsProvider).randomHospitalsStream;
});

final streamKenyanHospitalsProvider =
    Provider<_StreamKenyanHospitalsHandler>((ref) {
  return _StreamKenyanHospitalsHandler(
    hospitalServerClient: ref.read(hostpitalClientProvider),
  );
});
