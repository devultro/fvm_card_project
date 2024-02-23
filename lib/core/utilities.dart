import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

String formatTransactionDate(String raw) {
  return "${raw.substring(0, 4)}-${raw.substring(4, 6)}-${raw.substring(6, 8)}";
}

String formatTransactionTime(String raw) {
  return "${raw.substring(0, 2)}:${raw.substring(2, 4)}:${raw.substring(4, 6)}";
}

String formatTransactionBalance(int raw) {
  if (raw == 0) {
    return "0.00";
  } else if (raw > 0) {
    return "${(raw / 100).floor()}.${(raw % 100).toString().padLeft(2, "0")}";
  } else {
    return "-${formatTransactionBalance(-raw)}";
  }
}

T? getEnumFromString<T>(Iterable<T> values, String value) {
  return values
      .firstWhereOrNull((type) => type.toString().split(".").last == value);
}

String enumToString<T>(T value) {
  return value.toString().split('.').last;
}

List<int> decodeHexString(String hex) {
  var result = <int>[];
  for (int i = 0; i < hex.length; i += 2) {
    result.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return result;
}

extension PlatformExceptionExtension on PlatformException {
  Map<String, dynamic> asMap() {
    return {
      "code": code,
      "message": message,
      "details": details.toString()
    };
  }

  String toJsonString() => jsonEncode(asMap());

  String toDetailString() {
    var result = '$code $message';
    if (details != null) {
      result += ' (${details.toString()})';
    }
    return result;
  }
}

enum WebViewOwner { Home }

WebViewOwner webviewOwner = WebViewOwner.Home;

class WebViewEvent {
  final String? message;
  final bool reload;

  WebViewEvent({this.reload = false, this.message});
}

class WebViewManager {
  final Map<WebViewOwner, StreamController<WebViewEvent>> _streams = {
    for (final owner in WebViewOwner.values) owner: StreamController.broadcast()
  };
  WebViewController? _cont;

  late JavascriptChannel channel =
      JavascriptChannel(name: "nfsee", onMessageReceived: _dispatch);

  _dispatch(JavascriptMessage msg) {
    log("[Webview] Incoming msg ${msg.message}");
    final ev = WebViewEvent(message: msg.message);
    _streams[webviewOwner]?.add(ev);
  }

  onWebviewInit(WebViewController cont) {
    log("[Webview] Init");
    _cont = cont;
    reload();
  }

  onWebviewPageLoad(String _url) {
    for (final stream in _streams.values) {
      stream.add(WebViewEvent(reload: true));
    }
  }

  Future<void> reload() async {
    if (_cont == null) return;
    WebViewController cont = _cont!;
    await cont.loadHtmlString("<!DOCTYPE html>");
    await cont.runJavascript(await rootBundle.loadString('assets/ber-tlv.js'));
    await cont
        .runJavascript(await rootBundle.loadString('assets/crypto-js.js'));
    await cont.runJavascript(await rootBundle.loadString('assets/crypto.js'));
    await cont.runJavascript(await rootBundle.loadString('assets/reader.js'));
    await cont.runJavascript(await rootBundle.loadString('assets/felica.js'));
    await cont.runJavascript(await rootBundle.loadString('assets/codes.js'));
  }

  Future<void> run(String js) async {
    if (_cont == null) throw "Not initialized";
    log("[Webview] Run script $js");
    await _cont!.runJavascript(js);
  }

  Stream<WebViewEvent> stream(WebViewOwner owner) {
    return _streams[owner]!.stream;
  }
}
