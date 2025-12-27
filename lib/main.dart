import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Sivi',
      defaultTransition: Transition.fade,
      transitionDuration: Duration(milliseconds: 500),
      initialRoute: '/',
      getPages: Pages.getPages,
    );
  }
}
