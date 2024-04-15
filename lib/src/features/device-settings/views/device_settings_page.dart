import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ledconfig/src/core/dependency_injection.dart';
import 'package:ledconfig/src/features/device-settings/services/device_services.dart';
import 'package:ledconfig/src/features/device-settings/services/wifi_prov_ble_services.dart';

class DeviceSettingsPage extends StatefulWidget {
  final Map data;
  const DeviceSettingsPage({required this.data, super.key});

  @override
  State<DeviceSettingsPage> createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
  DeviceService deviceServices = DeviceService();
  late WifiProvService wifiProvService;
  dynamic deviceShadow;

  bool shadowLoading = true;
  bool powerOn = true;

  late Color currentColor;

  @override
  void initState() {
    super.initState();
    loadDeviceShadow();
    connectBLE();
  }

  void connectBLE() {
    wifiProvService = AppDependencyInjector.getIt.get();
    wifiProvService.scanBleDevices();
  }

  void loadDeviceShadow() async {
    deviceShadow = await deviceServices.getDeviceShadow(
      projectId: widget.data["project_id"],
      fleetId: widget.data["fleet_id"],
      deviceId: widget.data["id"],
    );
    log(deviceShadow.toString());
    powerOn = deviceShadow["on"] ?? false;
    currentColor = Color.fromRGBO(
      deviceShadow["red"] ?? 0,
      deviceShadow["blue"] ?? 0,
      deviceShadow["green"] ?? 0,
      1,
    );

    setState(() {
      shadowLoading = false;
    });
  }

  void changeColor(Color newColor) {
    setState(() {
      currentColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.data["device_name"]).toString()),
        actions: [],
      ),
      body: (shadowLoading)
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FieldTile(
                    fieldName: "LED Color",
                    fieldAction: ColorPickerButton(
                      onDone: changeColor,
                      currentColor: currentColor,
                    )),
                FieldTile(
                  fieldName: "Power",
                  fieldAction: CupertinoSwitch(
                      value: powerOn,
                      onChanged: (value) {
                        setState(() {
                          powerOn = !powerOn;
                        });
                      }),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final shadow = {
                      "shadow": {
                        "blue": currentColor.blue,
                        "green": currentColor.green,
                        "on": powerOn,
                        "red": currentColor.red,
                      }
                    };

                    final response = await deviceServices.updateDeviceShadow(
                      projectId: widget.data["project_id"],
                      fleetId: widget.data["fleet_id"],
                      deviceId: widget.data["id"],
                      shadow: shadow,
                    );
                  },
                  child: const Text("Update Shadow"),
                ),
              ],
            ),
    );
  }
}

class FieldTile extends StatelessWidget {
  final Widget fieldAction;
  final String fieldName;
  const FieldTile({
    required this.fieldName,
    required this.fieldAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(fieldName),
          trailing: fieldAction,
        ),
      ),
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final Color currentColor;
  final void Function(Color color) onDone;
  const ColorPickerButton(
      {super.key, required this.onDone, required this.currentColor});

  @override
  _ColorPickerButtonState createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  void initState() {
    super.initState();
    currentColor = widget.currentColor;
  }

  late Color currentColor;

  void changeColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                setState(() => currentColor = color);
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                widget.onDone(currentColor);
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeColor(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentColor,
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
