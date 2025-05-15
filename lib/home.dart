import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kostgo/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3C8D1),
      body: SafeArea(
        child: SingleChildScrollView( // 👈 Wrap the content with scrollable view
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 99),
                  Container(
                    width: 360,
                    child: Image.asset("images/gambar1.png"),
                  ),
                  SizedBox(height: 60),
                  Text(
                    "Aplikasi yang memudahkan mencari\ntempat tinggal yang ideal.\nSiap membantu menemukan kost impianmu.",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFF022B60),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Explore Now",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Optional spacing at bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
