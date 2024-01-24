import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(BuildContext context, ScanModel scanModel) async{
  var _url = scanModel.valor;
  if (scanModel.tipus == 'http'){
    if(!await launch(_url)) throw 'Could not launch $_url';
  }else{
    Navigator.pushNamed(context, 'mapa', arguments: scanModel);
  }
}