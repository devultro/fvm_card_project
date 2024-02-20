import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fvm_card_project/Presentation/screen/platformpage.dart';
import 'package:fvm_card_project/core/utilities.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Presentation/screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen()
    );
  }

  // var _reading = false;
  // Exception? error;
  // final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  // new GlobalKey<ScaffoldMessengerState>();
  // WebViewManager webview = WebViewManager();
  //
  // Future<bool> _readTag(BuildContext context) async {
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
  //   await webview.reload();
  //   await webview.run(script);
  //
  //   bool cardRead = true;
  //   if ((await modal) != true) {
  //     await webview.run("pollErrorCallback('User cancelled operation')");
  //     cardRead = false;
  //   }
  //   _reading = false;
  //   return cardRead;
  // }
  //
  // Widget _buildReadModal(BuildContext context) {
  //   return Container(
  //       child: Padding(
  //           padding: const EdgeInsets.all(32),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text(
  //                 'Hold your phone near the NFC card / tag...',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 18),
  //               ),
  //               SizedBox(height: 10),
  //               Image.asset('assets/read.webp', height: 200),
  //             ],
  //           )));
  // }

}



