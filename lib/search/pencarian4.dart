import 'package:flutter/material.dart';
import 'package:kostgo/chat/chatDetailPage%20(2).dart';
import 'package:kostgo/chat/chatDetailPage1.dart';
import 'package:kostgo/screens/kost_impian.dart';
import 'package:kostgo/themes/colors_theme.dart';
import 'package:kostgo/themes/fonts_theme.dart';

class Pencarian4 extends StatelessWidget {
  const Pencarian4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 85,
            width: 420,
            decoration: const BoxDecoration(
              color: darkBlueColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 25,
                left: 9,
                right: 350,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: whiteColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Text(
              "Ini Kos yang Kami Temukan ",
              style: mediumBlackText.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: darkBlueColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kost Impian",
                          style: semiBoldBlackText.copyWith(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Wanita",
                            style: regularBlackText.copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            4,
                          ),
                          child: Image.asset(
                            'images/impian.png',
                            width: 97,
                            height: 130,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Muara Dua",
                                style: regularWhiteText.copyWith(fontSize: 12),
                              ),
                              const SizedBox(height: 50),
                              Text(
                                "K. Mandi Dalam, Wifi, Dll.",
                                style: regularWhiteText.copyWith(fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Harga: Rp 500.000/bulan",
                                style: semiBoldBlackText.copyWith(
                                  fontSize: 14,
                                  color: Colors.yellowAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const KostImpian(),
                              ),
                            );
                          },
                          child: Text(
                            "Lihat Detail",
                            style: semiBoldToskaText.copyWith(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 184),
                      child: Container(
                        width: 160,
                        height: 40,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Tanya Pemilik",
                            style: semiBoldBlueText.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
