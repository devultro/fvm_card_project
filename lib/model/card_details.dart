/// card_number : "4315813925138008"
/// expiration : "30/02"
/// atc : "65"
/// transactions : []
/// pin_retry : "N/A"
/// ndef : null

class CardDetails {
  CardDetails({
      String? cardNumber,
      String? expiration,
      String? atc,
      List<dynamic>? transactions,
      String? pinRetry,
      dynamic ndef,}){
    _cardNumber = cardNumber;
    _expiration = expiration;
    _atc = atc;
    _transactions = transactions;
    _pinRetry = pinRetry;
    _ndef = ndef;
}

  CardDetails.fromJson(dynamic json) {
    _cardNumber = json['card_number'];
    _expiration = json['expiration'];
    _atc = json['atc'];
    if (json['transactions'] != null) {
      _transactions = [];
      json['transactions'].forEach((v) {
        _transactions?.add(Null);
      });
    }
    _pinRetry = json['pin_retry'];
    _ndef = json['ndef'];
  }
  String? _cardNumber;
  String? _expiration;
  String? _atc;
  List<dynamic>? _transactions;
  String? _pinRetry;
  dynamic _ndef;
CardDetails copyWith({  String? cardNumber,
  String? expiration,
  String? atc,
  List<dynamic>? transactions,
  String? pinRetry,
  dynamic ndef,
}) => CardDetails(  cardNumber: cardNumber ?? _cardNumber,
  expiration: expiration ?? _expiration,
  atc: atc ?? _atc,
  transactions: transactions ?? _transactions,
  pinRetry: pinRetry ?? _pinRetry,
  ndef: ndef ?? _ndef,
);
  String? get cardNumber => _cardNumber;
  String? get expiration => _expiration;
  String? get atc => _atc;
  List<dynamic>? get transactions => _transactions;
  String? get pinRetry => _pinRetry;
  dynamic get ndef => _ndef;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['card_number'] = _cardNumber;
    map['expiration'] = _expiration;
    map['atc'] = _atc;
    if (_transactions != null) {
      map['transactions'] = _transactions?.map((v) => v.toJson()).toList();
    }
    map['pin_retry'] = _pinRetry;
    map['ndef'] = _ndef;
    return map;
  }

}