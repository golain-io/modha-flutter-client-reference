import '../../../core/dependency_injection.dart';
import '../../../core/services/golain_api_services.dart';

class DeviceService {
  late GolainApiService apiServices;

  DeviceService() {
    apiServices = AppDependencyInjector.getIt.get();
  }

  Future getDeviceShadow({
    required String projectId,
    required String fleetId,
    required String deviceId,
  }) async {
    try {
      final response = await apiServices.get(
          endpoint:
              "/projects/$projectId/fleets/$fleetId/devices/$deviceId/shadow");

      return response.data["data"]["shadow"];
    } catch (e) {
      return null;
    }
  }

  Future updateDeviceShadow(
      {required String projectId,
      required String fleetId,
      required String deviceId,
      required Map shadow}) async {
    try {
      final response = await apiServices.post(
        endpoint:
            "/projects/$projectId/fleets/$fleetId/devices/$deviceId/shadow",
        body: shadow,
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
