import 'package:get_it/get_it.dart';
import 'package:ledconfig/src/core/services/golain_api_services.dart';
import 'package:ledconfig/src/features/authentication/services/authentication_service.dart';
import 'package:ledconfig/src/features/device-settings/services/wifi_prov_ble_services.dart';

class AppDependencyInjector {
  static final getIt = GetIt.instance;
  static void setUpAppDependencies() {
    getAuthService();
    getApiService();
    getWifiProvService();
  }

  static void getAuthService() {
    getIt.registerLazySingleton<AuthenticationService>(
        () => AuthenticationService());
  }

  static void getApiService() {
    getIt.registerLazySingleton<GolainApiService>(() => GolainApiService());
  }

  static void getWifiProvService() {
    getIt.registerLazySingleton<WifiProvService>(() => WifiProvService());
  }
}
