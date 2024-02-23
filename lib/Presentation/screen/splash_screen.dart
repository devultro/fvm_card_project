import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fvm_card_project/Presentation/screen/home_screen.dart';
import 'package:lottie/lottie.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
            () =>

      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: Lottie.asset("assets/lottie_payment.json"),
              ),
              const SizedBox(
                height: 10,
              ),

              const Text(
                "Tap to Pay App",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ],
          ),
        ));
  }
}
