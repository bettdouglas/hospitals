import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospitals_riverpod/src/common_widgets.dart';
import 'package:hospitals_riverpod/src/constants.dart';
import 'package:hospitals_riverpod/src/generated/contract.pb.dart';
import 'package:hospitals_riverpod/src/generated/contract.pbgrpc.dart';

final allHospitalsFutureProvider = FutureProvider<List<Hospital>>(
  (ref) async {
    final response = await ref
        .read(hostpitalClientProvider)
        .getHospitals(Empty()); // our future
    return response.hospitals; //returns a list of all the hospitals
  },
);

class AllHospitalsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Hospital>> state = ref.watch(allHospitalsFutureProvider);

    return state.when(
      // when we get the data
      data: (hospitals) => HospitalsListView(hospitals: hospitals),
      // when we're loading
      loading: () => Center(child: CircularProgressIndicator()),
      // when we have an error
      error: (err, stackTrace) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(err.toString()),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.refresh(allHospitalsFutureProvider),
              child: Container(height: 20, child: Text('Try Again')),
            )
          ],
        ),
      ),
    );
  }
}

class AllHospitalsPage extends StatelessWidget {
  const AllHospitalsPage({Key? key}) : super(key: key);

  static String get route => '/all-hospitals';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Kenyan Hospitals'),
      ),
      body: AllHospitalsView(),
    );
  }
}
