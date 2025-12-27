import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OffersView extends StatelessWidget {
  const OffersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Offers",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,fontSize: 30)),
      ),
    );
  }
}
