
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import 'Presentation/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
      //     readCard: () {
      //   return this._readTag(this.context);
      // }
      ),
    );
  }

  // var _reading = false;
  // Exception? error;
  // final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  // new GlobalKey<ScaffoldMessengerState>();
  // PageController? topController;

  // Future<bool> _readTag(BuildContext context) async {
  //   // Because we are launching an modal bottom sheet, user should not be able to intereact with the app anymore
  //   assert(!_reading);
  //
  //   _reading = true;
  //   var modal;
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     modal = showModalBottomSheet(
  //       context: context,
  //       builder: this._buildReadModal,
  //     );
  //   } else {
  //     modal = Future.value(true);
  //   }
  //
  //   final script = await rootBundle.loadString('assets/read.js');
  //   // Reload before read to ensure an clear state
  //   await webview.reload();
  //   await webview.run(script);
  //   // this._mockRead();
  //
  //   bool cardRead = true;
  //   if ((await modal) != true) {
  //     // closed by user, reject the promise
  //     await webview.run("pollErrorCallback('User cancelled operation')");
  //     cardRead = false;
  //   }
  //
  //   _reading = false;
  //   return cardRead;
  // }

}


