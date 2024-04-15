import 'dart:developer';

import 'package:flutter_esp_ble_prov/flutter_esp_ble_prov.dart';

class WifiProvService {
  final _flutterEspBleProvPlugin = FlutterEspBleProv();
  final _defaultDevicePrefix = "PROV_123";

  Future scanBleDevices() async {
    final scannedDevices =
        await _flutterEspBleProvPlugin.scanBleDevices(_defaultDevicePrefix);
    log("here");
    log(scannedDevices.toString());

    await scanWifi();
  }

  Future scanWifi() async {
    final scannedNetworks =
        await _flutterEspBleProvPlugin.scanWifiNetworks("PROV_123", "abcd1234");

    log(scannedNetworks.toString());
    await provisionWifi();
  }

  Future provisionWifi() async {
    await _flutterEspBleProvPlugin.provisionWifi(
        "PROV_123", "abcd1234", "Quoppo Ventures ", "Quopeupp");
  }
}
