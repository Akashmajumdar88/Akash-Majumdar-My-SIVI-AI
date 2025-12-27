import 'package:get/get.dart';

class Routes {
  static Future<void> splashScreen() async {
    return await Get.offAllNamed("/");
  }
  static Future<void> dashboardView() async {
    return await Get.offAllNamed("/DashboardView");
  }
}