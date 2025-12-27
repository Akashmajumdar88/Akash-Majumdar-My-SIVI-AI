import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Settings",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,fontSize: 30)),
      ),
    );
  }
}
