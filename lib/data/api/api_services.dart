import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fvm_card_project/utils/colors/custom_color.dart';

import 'package:http/http.dart' as http;

String baseUrl =
    "https://stripe-card-tokenization.onrender.com/api/card-tokenized";

Future<http.Response> sendPostRequest(String? token, context) async {

  Map data = {"card_token": token.toString()};

  var headers = {
    'Content-Type':'application/json',
  };
  var response = await http.post(Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(data));


  try {
    if (response.statusCode == 200) {
      print('Api called succesfullty');
      return response;
    } else {
      SnackBar snackBar = const SnackBar(
        content: Text('Please try again'),
        backgroundColor:  CustomColors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return response;
    }
  } catch (e) {
    print(e.toString(),
    );
  }
  return response;
}
