import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fvm_card_project/Presentation/screen/card_details.dart';
import 'package:fvm_card_project/Presentation/widgets/header.dart';
import 'package:fvm_card_project/core/utilities.dart';
import 'package:fvm_card_project/model/models.dart';
import 'package:fvm_card_project/utils/colors/custom_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import '../widgets/card_view.dart';

class HomeScreen extends StatefulWidget {
  // final Future<bool> Function() readCard;
  const HomeScreen({super.key /*, required this.readCard*/
      });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._initSelf();
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    this._initSelf();
  }

  void _initSelf() {
    _webViewListener =
        webview.stream(WebViewOwner.Main).listen(_onReceivedMessage);
    // topController = PageController(
    //   initialPage: this.currentTop,
    // );
    // Webview should reload when it's initialized. So we don't need to call reload here
    // webview.reload();
  }

  @override
  void dispose() {
    // topController!.dispose();
    super.dispose();
    _webViewListener?.cancel();
    _webViewListener = null;
  }

  void showSnackbar(SnackBar snackBar) {
    if (_scaffoldMessengerKey.currentState != null) {
      _scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    }
  }

  void _onReceivedMessage(WebViewEvent ev) async {
    if (ev.reload) return; // Main doesn't care about reload events
    assert(ev.message != null);

    var scriptModel = ScriptDataModel.fromJson(json.decode(ev.message!));
    log('[Main] Received action ${scriptModel.action} from script');
    switch (scriptModel.action) {
      case 'poll':
        error = null;
        try {
          final tag =
              await FlutterNfcKit.poll(iosAlertMessage: 'Hold your phone near the NFC card / tag...');
          final json = tag.toJson();

          // try to read ndef and insert into json
          try {
            final ndef = await FlutterNfcKit.readNDEFRawRecords();
            json["ndef"] = ndef;
          } on PlatformException catch (e) {
            // allow readNDEF to fail
            json["ndef"] = null;
            log('Silent readNDEF error: ${e.toDetailString()}');
          }

          await webview.run("pollCallback(${jsonEncode(json)})");
          FlutterNfcKit.setIosAlertMessage('Reading you NFC card / tag...');
        } on PlatformException catch (e) {
          error = e;
          // no need to do anything with FlutterNfcKit, which will reset itself
          log('Poll error: ${e.toDetailString()}');
          _closeReadModal(this.context);
          showSnackbar(SnackBar(
              content:
                  Text('${'Read failed'}: ${e.toDetailString()}')));
          // reject the promise
          await webview.run("pollErrorCallback(${e.toJsonString()})");
        }
        break;

      case 'transceive':
        try {
          log('TX: ${scriptModel.data}');
          final rapdu =
              await FlutterNfcKit.transceive(scriptModel.data as String);
          log('RX: $rapdu');
          await webview.run("transceiveCallback('$rapdu')");
        } on PlatformException catch (e) {
          error = e;
          // we need to explicitly finish the reader session now **in the script** to stop any following operations,
          // otherwise a following poll might crash the entire application,
          // because ReaderMode is still enabled, and the obselete MethodChannel.Result will be re-used.
          log('Transceive error: ${e.toDetailString()}');
          _closeReadModal(this.context);
          showSnackbar(SnackBar(
              content:
                  Text('${'Read failed'}: ${e.toDetailString()}')));
          await webview.run("transceiveErrorCallback(${e.toJsonString()})");
        }
        break;

      case 'report':
        _closeReadModal(this.context);
        /* final id = */
        // await bloc.addDumpedRecord(jsonEncode(scriptModel.data));
        // home.scrollToNewCard();
        break;

      case 'finish':
        if (error != null) {
          await FlutterNfcKit.finish(iosErrorMessage: 'Read failed');
          error = null;
        } else {
          await FlutterNfcKit.finish(iosAlertMessage: 'Read succeeded');
        }
        break;

      case 'log':
        log('Log from script: ${scriptModel.data.toString()}');
        break;

      default:
        assert(false, 'Unknown action ${scriptModel.action}');
        break;
    }
  }

  var _reading = false;
  Exception? error;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  // PageController? topController;
  WebViewManager webview = WebViewManager();
  StreamSubscription? _webViewListener;

  // int currentTop = 1;

  @override
  Widget build(BuildContext context) {
    // WebViewManager webview = WebViewManager();

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        backgroundColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: "Home",
            backgroundColor: CustomColors.blue.withOpacity(0.8),
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner), label: "Permission"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: "Payments"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Setting"),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(child:  WebView(
            onWebViewCreated: webview.onWebviewInit,
            onPageFinished: webview.onWebviewPageLoad,
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: {webview.channel},
          ),),
          Positioned.fill(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const CardView(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Hello User,',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Card(
                        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.transfer_within_a_station,
                                  size: 40,
                                  color: CustomColors.blue,
                                ),
                                Text(
                                  'Transfer',
                                  style: TextStyle(
                                      color: CustomColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Card(
                        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.monetization_on_rounded,
                                  size: 40,
                                  color: CustomColors.blue,
                                ),
                                Text(
                                  'Pay bill',
                                  style: TextStyle(
                                      color: CustomColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Card(
                        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 40,
                                  color: CustomColors.blue,
                                ),
                                Text(
                                  'View History',
                                  style: TextStyle(
                                      color: CustomColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // final cardRead = await widget.readCard();
                        // if (!cardRead) return;
                        // this.addCard();
                        this._readTag(this.context);

                        log("CARD read");
                        // showModalBottomSheet<void>(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return SizedBox(
                        //       height: 380,
                        //       child: Center(
                        //         child: Column(
                        //           // mainAxisAlignment: MainAxisAlignment.start,
                        //           // mainAxisSize: MainAxisSize.min,
                        //           children: <Widget>[
                        //             GestureDetector(
                        //               child: const Padding(
                        //                 padding: EdgeInsets.all(10),
                        //                 child: Row(
                        //                   mainAxisAlignment: MainAxisAlignment.end,
                        //                   children: [
                        //                     Icon(
                        //                       Icons.cancel,
                        //                       size: 28,
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               onTap: () {
                        //                 Navigator.pop(context);
                        //               },
                        //             ),
                        //             const Padding(
                        //               padding: EdgeInsets.only(top: 5),
                        //               child: Text(
                        //                 'Ready To Scan',
                        //                 style: TextStyle(fontSize: 30),
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding:
                        //               const EdgeInsets.symmetric(vertical: 25),
                        //               child: SvgPicture.asset(
                        //                 'assets/images/contactless.svg',
                        //                 semanticsLabel: 'My SVG Image',
                        //               ),
                        //             ),
                        //             const Padding(
                        //               padding: EdgeInsets.symmetric(vertical: 20),
                        //               child: Text(
                        //                 'Hold Your Phone Near the Card',
                        //                 style: TextStyle(fontSize: 18),
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               width:
                        //               MediaQuery.of(context).size.width * 0.9,
                        //               height: 60,
                        //               child: TextButton(
                        //                   onPressed: () {
                        //                     Navigator.push(
                        //                         context,
                        //                         MaterialPageRoute(
                        //                             builder: (context) =>
                        //                             const CardDetailsScreen()));
                        //                   },
                        //                   style: TextButton.styleFrom(
                        //                       backgroundColor: CustomColors.blue,
                        //                       foregroundColor: CustomColors.white,
                        //                       shape: RoundedRectangleBorder(
                        //                           borderRadius:
                        //                           BorderRadius.circular(15))),
                        //                   child: const Text(
                        //                     "Scan",
                        //                     style: TextStyle(
                        //                         fontFamily: "RedHatDisplay",
                        //                         fontSize: 18,
                        //                         fontWeight: FontWeight.w500),
                        //                   )),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Card(
                          // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.tap_and_play,
                                    size: 40,
                                    color: CustomColors.blue,
                                  ),
                                  Text(
                                    'Tap to Pay',
                                    style: TextStyle(
                                        color: CustomColors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),)
        ],
      )



    );
  }

  Future<bool> _readTag(BuildContext context) async {
    assert(!_reading);

    _reading = true;
    var modal;
    if (defaultTargetPlatform == TargetPlatform.android) {
      modal = showModalBottomSheet(
        context: context,
        builder: this._buildReadModal,
      );
    } else {
      modal = Future.value(true);
    }

    final script = await rootBundle.loadString('assets/read.js');
    await webview.reload();
    await webview.run(script);

    bool cardRead = true;
    if ((await modal) != true) {
      await webview.run("pollErrorCallback('User cancelled operation')");
      cardRead = false;
    }
    _reading = false;
    return cardRead;
  }

  void _closeReadModal(BuildContext context) {
    if (_reading && defaultTargetPlatform != TargetPlatform.iOS) {
      Navigator.of(context).pop(true);
    }
  }

  Widget _buildReadModal(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.cancel,
                      size: 28,
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Ready To Scan',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 25),
              child: SvgPicture.asset(
                'assets/images/contactless.svg',
                semanticsLabel: 'My SVG Image',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Hold Your Phone Near the Card',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              width:
              MediaQuery.of(context).size.width * 0.9,
              height: 60,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const CardDetailsScreen()));
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: CustomColors.blue,
                      foregroundColor: CustomColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15))),
                  child: const Text(
                    "Scan",
                    style: TextStyle(
                        fontFamily: "RedHatDisplay",
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )),
            ),
          ],
        ),
      ),
    );
    // return Container(
    //     child: Padding(
    //         padding: const EdgeInsets.all(32),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             Text(
    //               'Hold your phone near the NFC card / tag...',
    //               textAlign: TextAlign.center,
    //               style: TextStyle(fontSize: 18),
    //             ),
    //             SizedBox(height: 10),
    //             Image.asset('assets/read.webp', height: 200),
    //           ],
    //         )));
  }
}
