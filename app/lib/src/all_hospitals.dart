import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospitals_riverpod/src/common_widgets.dart';
import 'package:hospitals_riverpod/src/constants.dart';
import 'package:hospitals_riverpod/src/generated/contract.pb.dart';
import 'package:hospitals_riverpod/src/generated/contract.pbgrpc.dart';

final allHospitalsFutureProvider = FutureProvider<List<Hospital>>(
  (ref) async {
    final response = await hospitalClient.getHospitals(Empty()); // our future
    return response.hospitals; //returns a list of all the hospitals
  },
);

class AllHospitalsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<List<Hospital>> state = watch(allHospitalsFutureProvider);

    return state.when(
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
            onPressed: () => context.refresh(allHospitalsFutureProvider),
            child: Container(height: 20, child: Text('Try Again')),
          )
        ],
      ),
    );
  }
}

class AllHospitalsPage extends StatelessWidget {
  const AllHospitalsPage({Key? key}) : super(key: key);

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
