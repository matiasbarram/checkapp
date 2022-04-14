// ignore_for_file: avoid_print

import 'package:checkapp/models/scan_model.dart';
import 'package:flutter/material.dart';

class ScanQrProvider extends ChangeNotifier {
  String qrResp = '';

  nuevoScan() {
    final scanmodmel = ScanModel.fromJson(qrResp);
    print("id: " + scanmodmel.id.toString());
    print("Nombre de la empresa: " + scanmodmel.name);
    print("Dirección de la empresa: " + scanmodmel.location);
    //hacer algo con el modelo

    //notifyListeners();
  }
}
