import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fvm_card_project/Presentation/screen/congratulations_screen.dart';
import 'package:fvm_card_project/Presentation/widgets/my_text_field.dart';
import 'package:fvm_card_project/data/api/api_services.dart';
import 'package:fvm_card_project/utils/colors/custom_color.dart';
import 'package:http/src/response.dart';

class CardDetailsScreen extends StatelessWidget {
  CardDetailsScreen({
    super.key,
    required this.card_number,
    required this.expiry_date,
    required this.Card_Type,
  });

  final String card_number;
  final String expiry_date;
  final String Card_Type;
  String fname = '';
  String lname = '';
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final cvvController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 190,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/card_bg.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 30.0, right: 30.0),
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
                                const Text(
                                  'Card Number',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(card_number,
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.white)),
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
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
                                      Text('______',
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
                                      const Text('Expiry Date',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      Text(expiry_date,
                                          style: const TextStyle(
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
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        controller: fNameController,
                        hintText: 'First Name',
                        obscureText: false,
                        redonly: false,
                        keyboardType: TextInputType.text,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          PatternValidator('[a-zA-Z]',
                              errorText: 'Please enter valid name'),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        controller: lNameController,
                        hintText: 'Last Name',
                        obscureText: false,
                        redonly: false,
                        keyboardType: TextInputType.text,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          PatternValidator('[a-zA-Z]',
                              errorText: 'Please enter valid name'),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        controller: TextEditingController(text: card_number),
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
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              // validator: MultiValidator([
                              //   RequiredValidator(errorText: "* Required"),
                              // ]),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: MyTextField(
                              controller:
                                  TextEditingController(text: expiry_date),
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
                        controller: TextEditingController(text: Card_Type),
                        obscureText: false,
                        redonly: true,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                child: TextButton(
                    onPressed: () async {
                      fname = fNameController.text.toString();
                      lname = lNameController.text.toString();
                      String cvvnumber = cvvController.text.toString();

                      if (_formKey.currentState!.validate()) {
                        await generateStripeToken(
                            cvv: cvvnumber, context: context);
                      } else {
                        SnackBar snackBar = const SnackBar(
                          content: Text('Please fill in all field'),
                          backgroundColor: CustomColors.blue,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
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

  /// Genrate token
  Future<String?> generateStripeToken(
      { String? cvv, required context}) async {
    var prAge = expiry_date.toString().split("/");
    var year = prAge[0].trim();
    var month = prAge[1].trim();
    var cardHolderName = fname + lname;

    CardTokenParams cardParams = CardTokenParams(
      type: TokenType.Card,
      name: cardHolderName,
    );
    /// create stripe instance
    await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
      number: '4242424242424242',
      // number: card_number,
      cvc: cvv,
      expirationMonth: int.tryParse(month),
      expirationYear: int.tryParse("20$year"),
    ));

    /// create stripe token
    try {
      TokenData token = await Stripe.instance.createToken(
        CreateTokenParams.card(params: cardParams),
      );
      print("Flutter Stripe token details === ${token.toJson()}");
      print("Flutter Stripe token id ===  ${token.id}");

      Response response = await sendPostRequest(token.id,context);
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CongratulationsScreen()));
      } else if (response.statusCode == 400) {
        SnackBar snackBar = const SnackBar(
          content: Text('Bad Request'),
          backgroundColor:  CustomColors.blue,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response.statusCode == 404) {
        SnackBar snackBar = const SnackBar(
          content: Text('Not Found'),
          backgroundColor:  CustomColors.blue,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        SnackBar snackBar = const SnackBar(
          content: Text('Please fill correct details'),
          backgroundColor:  CustomColors.blue,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);      }
      return token.id;
    } on StripeException catch (e) {
      print("Flutter Stripe error === ${e.error.message}");
    }
    return null;
  }
}
