import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.hybrid;

  @override
  Widget build(BuildContext context) {
    final scanModel = ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition _puntInicial = CameraPosition(
      target: scanModel.getlatLNG(),
      zoom: 17,
      tilt: 50
    );

    Set<Marker> markers = new Set<Marker>();

    markers.add(new Marker(
      position: scanModel.getlatLNG(),
      markerId: MarkerId('1')
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: [
          IconButton(
            icon: Icon(Icons.center_focus_strong),
            onPressed: () {
              if (_controller.isCompleted) {
                _controller.future.then((GoogleMapController controller) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(_puntInicial),
                  );
                });
              }
            },
          )
        ],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: mapType,
        markers: markers,
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.change_circle),
        onPressed: () {
          mapType = mapType == MapType.normal ? MapType.hybrid : MapType.normal;
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
