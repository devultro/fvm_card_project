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
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import '../widgets/card_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? CardNumber;
  String? Expiry_Date;
  String? Card_Type;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSelf();
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    _initSelf();
  }

  void _initSelf() {
    _webViewListener =
        webview.stream(WebViewOwner.Home).listen(onReceivedMessage);
  }

  @override
  void dispose() {
    super.dispose();
    _webViewListener?.cancel();
    _webViewListener = null;
    CardNumber = '';
    Expiry_Date = '';
    Card_Type = '';
    print('card details field is clear === ');
  }

  void showSnackbar(SnackBar snackBar) {
    if (_scaffoldMessengerKey.currentState != null) {
      _scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    }
  }

  void onReceivedMessage(WebViewEvent ev) async {
    if (ev.reload) return; // Main doesn't care about reload events
    assert(ev.message != null);

    var scriptModel = ScriptDataModel.fromJson(json.decode(ev.message!));
    if (scriptModel.data != null) {
      try {
        log('[Main] Received action====== ${scriptModel.data['detail']} from script');
        Map<String, dynamic> detail = scriptModel.data['detail'];
        CardNumber = detail['card_number'];
        Expiry_Date = detail['expiration'];
        Card_Type = scriptModel.data['card_type'];
      } catch (e) {
        log(e.toString());
      }
    }

    switch (scriptModel.action) {
      case 'poll':
        error = null;
        try {
          final tag = await FlutterNfcKit.poll(
              iosAlertMessage: 'Hold your phone near the NFC card / tag...');
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
          _closeReadModal(context);
          showSnackbar(SnackBar(
              content: Text('${'Read failed'}: ${e.toDetailString()}')));
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
          log('Transceive error: ${e.toDetailString()}');
          _closeReadModal(context);
          showSnackbar(SnackBar(
              content: Text('${'Read failed'}: ${e.toDetailString()}')));
          await webview.run("transceiveErrorCallback(${e.toJsonString()})");
        }
        break;

      case 'report':
        _closeReadModal(context);
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
  GlobalKey<ScaffoldMessengerState>();

  WebViewManager webview = WebViewManager();
  StreamSubscription? _webViewListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.white,
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: CustomColors.white,
            unselectedItemColor: CustomColors.white,
            backgroundColor: CustomColors.blue,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                backgroundColor: CustomColors.blue,
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.document_scanner), label: "Permission"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.payment), label: "Payments"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Setting"),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: WebView(
                onWebViewCreated: webview.onWebviewInit,
                onPageFinished: webview.onWebviewPageLoad,
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: {webview.channel},
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(),
                      const CardView(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Hello User,',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GridView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
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
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
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
                              await _readTag(this.context);
                              log("CARD read");

                              if (CardNumber != null && Expiry_Date != null && Card_Type != null) {
                                Timer(const Duration(seconds: 4),(){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CardDetailsScreen(
                                              card_number: CardNumber!, expiry_date: Expiry_Date!, Card_Type: Card_Type!)));
                                });

                              } else {
                                SnackBar snackBar = const SnackBar(
                                  content: Text('Card is not read...please try again'),
                                  backgroundColor:  CustomColors.blue,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
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
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<bool> _readTag(BuildContext context) async {
    assert(!_reading);

    _reading = true;
    var modal;
    if (defaultTargetPlatform == TargetPlatform.android) {
      modal = showModalBottomSheet(
        context: context,
        builder: _buildReadModal,
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
      height: MediaQuery.of(context).size.height * 0.45,
      child: Center(
        child: Column(
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
            const Text(
              'Ready To Scan',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: Lottie.asset("assets/lottie_scan.json"),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Text(
                'Hold Your Phone Near the Card',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
