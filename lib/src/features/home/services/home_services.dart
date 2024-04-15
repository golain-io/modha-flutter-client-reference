import '../../../core/dependency_injection.dart';
import '../../../core/services/golain_api_services.dart';

class HomeService {
  late GolainApiService apiServices;

  HomeService() {
    apiServices = AppDependencyInjector.getIt.get();
  }

  Future fetchDevices({required String projectId}) async {
    try {
      final response =
          await apiServices.get(endpoint: "/projects/$projectId/devices");

      return response.data["data"]["devices"];
    } catch (e) {
      return null;
    }
  }
}
