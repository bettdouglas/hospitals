import 'package:flutter/material.dart';
import 'package:hospitals_riverpod/src/generated/index.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key, required this.msg}) : super(key: key);

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(msg),
        SizedBox(height: 20),
        CircularProgressIndicator(),
      ],
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    Key? key,
    required this.error,
    required this.msg,
    this.stackTrace,
    required this.retryFunction,
  }) : super(key: key);

  final Object error;
  final StackTrace? stackTrace;
  final String msg;
  final VoidCallback retryFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Icon(Icons.error),
        SizedBox(height: 20),
        Text(error.toString()),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: retryFunction,
          child: Container(
            alignment: Alignment.center,
            height: 20,
            child: Text('Try Again?'),
          ),
        )
      ],
    );
  }
}

class HospitalsListView extends StatelessWidget {
  final List<Hospital> hospitals;

  const HospitalsListView({
    Key? key,
    required this.hospitals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, idx) => HospitalTile(
        hospital: hospitals[idx],
      ),
      itemCount: hospitals.length,
    );
  }
}

class HospitalTile extends StatelessWidget {
  final Hospital hospital;

  const HospitalTile({
    Key? key,
    required this.hospital,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(hospital.name[0]),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      title: Text(hospital.name),
      subtitle: Row(
        children: [
          Text(hospital.location),
          Text(
            '\t(${hospital.coordinate.latitude},${hospital.coordinate.longitude})',
          )
        ],
      ),
    );
  }
}
