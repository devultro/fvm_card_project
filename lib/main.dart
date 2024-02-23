import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fvm_card_project/Presentation/screen/splash_screen.dart';
import 'package:fvm_card_project/utils/colors/custom_color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /// use your account publish key
  Stripe.publishableKey = 'pk_test_51N57sBSC3tPkvwfjsQ8a6IUK6uNvAyqBZZwp8zuW7JnmuZSeuCQoYtbV4xtHAgdQO8wroVQ80je7DuFRorlu7yaW00o1nWzsjs';
  SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
    systemStatusBarContrastEnforced: false,
    statusBarColor: CustomColors.blue,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: CustomColors.white,
        scaffoldBackgroundColor: CustomColors.white,
      ),
      home: Splash_Screen()
    );
  }

}



