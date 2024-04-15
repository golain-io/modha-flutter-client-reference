import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ledconfig/src/core/dependency_injection.dart';
import 'package:ledconfig/src/features/authentication/views/login_page.dart';
import 'package:ledconfig/src/features/device-settings/views/device_settings_page.dart';
import 'package:ledconfig/src/features/home/services/home_services.dart';

import '../../authentication/services/authentication_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthenticationService authenticationService =
      AppDependencyInjector.getIt.get();
  late List data;
  bool devicesLoading = true;
  HomeService homeService = HomeService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    data = await homeService.fetchDevices(
        projectId: "8ba29606-4e26-43ba-86ab-c55bd5142a10");
    log(data.length.toString());
    setState(() {
      devicesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await authenticationService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route route) => false);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
      body: (devicesLoading)
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    title: Text(data[i]["device_name"].toString()),
                    subtitle: Text("Device desc"),
                    trailing: IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DeviceSettingsPage(
                                  data: data[i],
                                )));
                      },
                    ),
                  ),
                );
              }),
    );
  }
}
