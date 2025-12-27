import 'package:get/get.dart';
import '../routes/routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
        Routes.dashboardView();
    });
  }
}