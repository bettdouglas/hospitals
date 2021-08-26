import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

enum BaseTile { OSM, MB_DARK, MB_LIGHT, STAMEN }

class BaseMap extends StatelessWidget {
  final LatLng center;
  final Iterable<MarkerLayerOptions>? markerLayerOptionsList;
  final Iterable<PolygonLayerOptions>? polygonLayerOptionsList;
  final Iterable<PolylineLayerOptions>? polylineLayerOptionsList;
  final MarkerClusterLayerOptions? markerClusterLayerOptions;
  final double zoom;

  const BaseMap({
    Key? key,
    required this.center,
    this.markerLayerOptionsList,
    this.polygonLayerOptionsList,
    this.polylineLayerOptionsList,
    this.markerClusterLayerOptions,
    this.zoom = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layers = <LayerOptions>[
      TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
      ),
    ];

    if (markerLayerOptionsList != null) {
      layers.addAll(markerLayerOptionsList!);
    }

    if (polygonLayerOptionsList != null) {
      layers.addAll(polygonLayerOptionsList!);
    }

    if (polylineLayerOptionsList != null) {
      layers.addAll(polylineLayerOptionsList!);
    }

    if (markerClusterLayerOptions != null) {
      layers.add(markerClusterLayerOptions!);
    }

    return Container(
      child: FlutterMap(
        options: MapOptions(
          center: this.center,
          zoom: zoom,
          onTap: (point) {
            print(point);
          },
          plugins: [
            MarkerClusterPlugin(),
          ],
        ),
        layers: layers,
      ),
    );
  }
}
