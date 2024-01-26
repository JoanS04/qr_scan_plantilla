import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
Pantalla per mostrar el mapa.
*/

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  //Declaram el controlador del mapa
  Completer<GoogleMapController> _controller = Completer();

  //Declaram el tipus de mapa
  MapType mapType = MapType.hybrid;

  @override
  Widget build(BuildContext context) {
    final scanModel = ModalRoute.of(context)!.settings.arguments as ScanModel;

    //Declaram la posicio inicial del mapa, les coordenades del scan
    final CameraPosition _puntInicial = CameraPosition(
      target: scanModel.getlatLNG(),
      zoom: 17,
      tilt: 50
    );

    //Llista de marcadors del mapa
    Set<Marker> markers = new Set<Marker>();

    //Afegim el marcador a la llista
    markers.add(new Marker(
      position: scanModel.getlatLNG(),
      markerId: MarkerId('1')
    ));

    /*
    Scaffold per mostrar el mapa i una appbar amb un boto per centrar el mapa
    i un floating action button per canviar el tipus de mapa.
    */

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: [
          IconButton(
            icon: Icon(Icons.center_focus_strong),
            onPressed: () {
              //Mitjançant el controlador del mapa, centrem el mapa a la posicio inicial
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
      //Creacio del mapa amb la posicio inicial, el tipus de mapa, els marcadors i el controlador
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
