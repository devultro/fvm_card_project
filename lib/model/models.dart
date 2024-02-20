import 'package:flutter/cupertino.dart';

class Detail {
  const Detail({this.name, this.value, this.icon});

  final String? name;
  final String? value;
  final IconData? icon;
}

class ScriptDataModel {
  final String? action;
  final dynamic data;

  ScriptDataModel({this.action, this.data});

  ScriptDataModel.fromJson(Map map)
      : action = map['action'],
        data = map['data'];
}

enum CardType {
  UPCredit,
  UPDebit,
  UPSecuredCredit,
  Visa,
  MC,
  AMEX,
  JCB,
  Discover,
  CityUnion,
  TUnion,
  BMAC,
  LingnanPass,
  ShenzhenTong,
  WuhanTong,
  MacauPass,
  TMoney,
  Octopus,
  Tsinghua,
  ChinaResidentIDGen2,
  MifareUltralight,
  MifarePlus,
  MifareDESFire,
  MifareClassic,
  Unknown,
}

extension CardTypeExtension on CardType? {
  String getName(BuildContext context) {
    switch (this) {
      case CardType.UPCredit:
        return 'UnionPay Credit';
      case CardType.UPDebit:
        return 'UnionPay Debit';
      case CardType.UPSecuredCredit:
        return 'UnionPay Secured Credit';
      case CardType.Visa:
        return 'Visa';
      case CardType.MC:
        return 'MasterCard';
      case CardType.AMEX:
        return 'American Express';
      case CardType.JCB:
        return 'JCB';
      case CardType.Discover:
        return 'Discover';
      case CardType.CityUnion:
        return 'City Union';
      case CardType.TUnion:
        return 'T Union';
      case CardType.BMAC:
        return 'Beijing Yikatong';
      case CardType.LingnanPass:
        return 'Lingnan Pass';
      case CardType.ShenzhenTong:
        return 'Shenzhen Tong';
      case CardType.WuhanTong:
        return 'Wuhan Tong';
      case CardType.MacauPass:
        return 'Macau Pass';
      case CardType.TMoney:
        return 'T-Money';
      case CardType.Octopus:
        return 'Octopus';
      case CardType.Tsinghua:
        return 'Tsinghua University Campus Card';
      case CardType.ChinaResidentIDGen2:
        return 'China Resident ID Card';
      case CardType.MifareUltralight:
        return'MIFARE Ultralight';
      case CardType.MifarePlus:
        return 'MIFARE Plus';
      case CardType.MifareDESFire:
        return 'MIFARE DESFire';
      case CardType.MifareClassic:
        return 'MIFARE Classic';
      case CardType.Unknown:
      default:
        return 'Unknown';
    }
  }
}

enum ProcessingCode { Authorization, BalanceInquiry, Cash, Void, MobileTopup }

extension ProcessingCodeExtension on ProcessingCode? {
  String getName(BuildContext context) {
    switch (this) {
      case ProcessingCode.Authorization:
        return 'Authorization';
      case ProcessingCode.BalanceInquiry:
        return 'Balance Inquiry';
      case ProcessingCode.Cash:
        return 'Cash';
      case ProcessingCode.MobileTopup:
        return 'Mobile Topup';
      case ProcessingCode.Void:
        return 'Void';
      default:
        return 'Unknown';
    }
  }
}

enum PBOCTransactionType { Load, Purchase, CompoundPurchase }

extension PBOCTransactionTypeExtension on PBOCTransactionType {
  String getName(BuildContext context) {
    switch (this) {
      case PBOCTransactionType.Load:
        return 'Load';
      case PBOCTransactionType.Purchase:
        return 'Purchase';
      case PBOCTransactionType.CompoundPurchase:
        return 'Compound Purchase';
      default:
        return 'Unknown';
    }
  }
}

enum BeijingSubway {
  Line1,
  Line2,
  Line4,
  Line5,
  Line6,
  Line7,
  Line8,
  Line9,
  Line10,
  Line13,
  Line14,
  Line15,
  Line16,
  Xijiao,
  DaxingAirport,
  Daxing,
  Changping,
  Fangshan,
  Yizhuang,
  Batong,
  CapitalAirport
}

extension BeijingSubwayExtension on BeijingSubway {
  String getName(BuildContext context) {
    switch (this) {
      case BeijingSubway.Line1:
        return 'Line 1';
      case BeijingSubway.Line2:
        return 'Line 2';
      case BeijingSubway.Line4:
        return 'Line 4';
      case BeijingSubway.Line5:
        return 'Line 5';
      case BeijingSubway.Line6:
        return 'Line 6';
      case BeijingSubway.Line7:
        return 'Line 7';
      case BeijingSubway.Line8:
        return 'Line 8';
      case BeijingSubway.Line9:
        return 'Line 9';
      case BeijingSubway.Line10:
        return 'Line 10';
      case BeijingSubway.Line13:
        return 'Line 13';
      case BeijingSubway.Line14:
        return 'Line 14';
      case BeijingSubway.Line15:
        return 'Line 15';
      case BeijingSubway.Line16:
        return 'Line 16';
      case BeijingSubway.Xijiao:
        return 'Xijiao Line';
      case BeijingSubway.DaxingAirport:
        return 'Daxing Airport Line';
      case BeijingSubway.Daxing:
        return 'Daxing Line';
      case BeijingSubway.Changping:
        return 'Changping Line';
      case BeijingSubway.Fangshan:
        return 'Fangshan Line';
      case BeijingSubway.Yizhuang:
        return 'Yizhuang Line';
      case BeijingSubway.Batong:
        return 'Batong Line';
      case BeijingSubway.CapitalAirport:
        return 'Capital Airport Line';
      default:
        return "Unknown";
    }
  }
}

const String DEFAULT_CONFIG = '{}';
