import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'Presentation/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51Oh58ESJMxlzEOpaWs9zmkBfAPUShgcVM20RdPlum2inLJutEkQ95fnZjBp33a3YsFZ9H0sHCsNpltq04tZb5Vd600gJiA28gy';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,

      home: HomeScreen()
    );
  }

}



