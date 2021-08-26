import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:hospitals_riverpod/src/generated/index.dart';
import 'base_map.dart';
import 'package:latlong2/latlong.dart';

class HospitalsMapView extends StatelessWidget {
  final List<Hospital> hospitals;

  HospitalsMapView({
    Key? key,
    required this.hospitals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clusters = MarkerClusterLayerOptions(
      builder: (context, markers) {
        return FloatingActionButton(
          onPressed: null,
          child: Text(markers.length.toString()),
        );
      },
      size: Size(40, 40),
      maxClusterRadius: 70,
      fitBoundsOptions: FitBoundsOptions(padding: EdgeInsets.all(20.04)),
      markers: hospitals.map((e) => makeMarker(e, context)).toList(),
    );

    return BaseMap(
      center: LatLng(0.60979, 37.686),
      zoom: 6,
      markerClusterLayerOptions: clusters,
    );
  }

  Marker makeMarker(Hospital hospital, BuildContext context) {
    return Marker(
      point: LatLng(
        hospital.coordinate.latitude,
        hospital.coordinate.longitude,
      ),
      builder: (context) => MarkerBuilder(
        hospital: hospital,
      ),
    );
  }
}

class MarkerBuilder extends StatelessWidget {
  final Hospital hospital;

  const MarkerBuilder({
    Key? key,
    required this.hospital,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(
        Icons.location_pin,
        color: Colors.red,
      ),
      onTap: () {
        showBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.33,
              width: double.infinity,
              color: Colors.black,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    highlightColor: Colors.red,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      hospital.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      hospital.location,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

extension AsLatLng on Location {
  LatLng get asLatLng => LatLng(latitude, longitude);
}
