import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 20.0,bottom: 20.0),
      child: SizedBox(
        height: 200,
        child: Container(
          height: 220,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/card_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
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
                            'Card number',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          Text('**** **** **** ****', style: TextStyle(fontSize: 24, color: Colors.white)),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Card name', style: TextStyle(fontSize: 14, color: Colors.white)),
                                Text('_________', style: TextStyle(fontSize: 20, color: Colors.white)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Expiry Date', style: TextStyle(fontSize: 14, color: Colors.white)),
                                Text('MM/YY', style: TextStyle(fontSize: 20, color: Colors.white)),
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
      ),
    );
  }
}
