import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final map = new MapController();

  String mapType = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Coordinates'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFloatingButton(context, scan),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _createMap(),
        _createMarkers(scan),
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/'
          '{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
        'accessToken':
            'pk.eyJ1Ijoia2FudXgyNzI1IiwiYSI6ImNrZTYwaGZodzE4OWozMXBkbjU1bGw2ZWYifQ.aLojR2ex4jTREPRbP8Q6_g',
        'id': 'mapbox/$mapType'
        // streets, dark, light, outdoors, satellite
      },
    );
  }

  _createMarkers(ScanModel scan) {
    return MarkerLayerOptions(markers: [
      Marker(
        width: 100.0,
        height: 100.0,
        point: scan.getLatLng(),
        builder: (context) => Container(
          child: Icon(
            Icons.location_on,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
    ]);
  }

  Widget _createFloatingButton(BuildContext context, ScanModel scan) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (mapType == 'streets-v11') {
          mapType = 'dark-v10';
        } else if (mapType == 'dark-v10') {
          mapType = 'light-v10';
        } else if (mapType == 'light-v10') {
          mapType = 'outdoors-v11';
        } else if (mapType == 'outdoors-v11') {
          mapType = 'satellite-v9';
        } else {
          mapType = 'streets-v11';
        }

        //Logica para cambiar de Estilo
        setState(() {});

        //movimiento #1 al maximo de zoom
        map.move(scan.getLatLng(), 30);

        //Regreso al Zoom Deseado después de unos Milisegundos
        Future.delayed(Duration(milliseconds: 50), () {
          map.move(scan.getLatLng(), 15);
        });
      },
    );
  }
}
