import 'package:get/get.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/splash_binding.dart';
import '../view/dashboard_view.dart';
import '../view/splash_view.dart';

class Pages {
  static final List<GetPage<dynamic>> getPages = [
    GetPage(
      name: "/",
      page: () => SplashView(),
      popGesture: true,
      binding: SplashBinding(),
      showCupertinoParallax: true
    ),
    GetPage(
      name: "/DashboardView",
      page: () => DashboardView(),
      popGesture: true,
      binding: DashboardBinding(),
      showCupertinoParallax: true,
    ),
  ];
}