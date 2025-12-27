import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());
    return Scaffold(
      backgroundColor: Color(0xFFED8023),
      body: Center(child: Text("My SiVI AI",
        style: GoogleFonts.montserrat(fontSize: 35,fontWeight: FontWeight.w500,color: Colors.white))),
    );
  }
}
