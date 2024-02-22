import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fvm_card_project/core/utilities.dart';
import 'package:fvm_card_project/model/card.dart';
import 'package:fvm_card_project/model/models.dart';

import '../../utils/colors/custom_color.dart';
import '../widgets/my_text_field.dart';
import 'congratulations_screen.dart';

class CardDetailsScreen extends StatelessWidget {
  CardDetailsScreen(
      {super.key,
      required this.card_number,
      required this.expiry_date,
      required this.Card_Type});

  final String card_number;
  final String expiry_date;
  final String Card_Type;

  @override
  Widget build(BuildContext context) {
    final fNameController = TextEditingController();
    final lNameController = TextEditingController();
    final cardNumberController = TextEditingController(text: card_number);
    final cvvController = TextEditingController();
    final expirtDateController = TextEditingController(text: expiry_date);
    final cardTypeController = TextEditingController(text: Card_Type);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 190,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/card_bg.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child:  Center(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Card Number',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(card_number,
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white)),
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Card name',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text('SAVLIYA MILAN',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Expiry Date',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text(expiry_date,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text('card number ==${card_number}'),
              MyTextField(
                  controller: fNameController,
                  hintText: 'First Name',
                  obscureText: false,
                  redonly: false,
                  keyboardType: TextInputType.text),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                  controller: lNameController,
                  hintText: 'Last Name',
                  obscureText: false,
                  redonly: false,
                  keyboardType: TextInputType.text),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: cardNumberController,
                obscureText: false,
                redonly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyTextField(
                        controller: cvvController,
                        hintText: 'CVV',
                        redonly: false,
                        obscureText: false,
                        keyboardType: TextInputType.text),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: MyTextField(
                        controller: expirtDateController,
                        redonly: true,
                        obscureText: false,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                  controller: cardTypeController,
                  obscureText: false,
                   redonly: true,),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                child: TextButton(
                    onPressed: () {
                      String cvvnumber = cvvController.text.toString();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CongratulationsScreen()));

                      generateStripeToken(cvv: cvvnumber);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: CustomColors.blue,
                        foregroundColor: CustomColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: const Text(
                      "Pay",
                      style: TextStyle(
                          fontFamily: "RedHatDisplay",
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> generateStripeToken({required String cvv}) async {
    // var prAge = expiryDate.value.split("/");
    var prAge = expiry_date.toString().split("/");
    var year = prAge[0].trim();
    var month = prAge[1].trim();

    CardTokenParams cardParams = const CardTokenParams(
      type: TokenType.Card,
      name: 'Nisha Shah ',
    );

    await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
      number: card_number,
      cvc: cvv,
      expirationMonth: int.tryParse(month),
      // expirationMonth: 12,
      // expirationYear: 2024,
      expirationYear: int.tryParse("20$year"),
    ));

    try {
      TokenData token = await Stripe.instance.createToken(
        CreateTokenParams.card(params: cardParams),
      );
      print("Flutter Stripe token details === ${token.toJson()}");
      print("Flutter Stripe cvv details === ${cvv}");

      print("Flutter Stripe token id ===  ${token.id}");
      return token.id;
    } on StripeException catch (e) {
      // Utils.errorSnackBar(e.error.message);
      print("Flutter Stripe error === ${e.error.message}");
    }
    return null;
  }

}
