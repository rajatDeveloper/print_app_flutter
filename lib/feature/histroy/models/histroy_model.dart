// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:print_app/feature/print_cart/models/print_cart_model.dart';

class HistroyModel {
  int? id;
  List<PrintCartModel>? print_cart;
  String? date;
  String? payment_mode;

  HistroyModel({
    this.id,
    this.print_cart,
    this.date,
    this.payment_mode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'print_cart': print_cart?.map((x) => x.toMap()).toList(),
      'date': date,
      'payment_mode': payment_mode,
    };
  }

  factory HistroyModel.fromMap(Map<String, dynamic> map) {
    return HistroyModel(
      id: map['id'] != null ? map['id'] as int : null,
      print_cart: map['print_cart'] != null
          ? List<PrintCartModel>.from(
              (map['print_cart'] as List<dynamic>).map<PrintCartModel>(
                (x) => PrintCartModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      date: map['date'] != null ? map['date'] as String : null,
      payment_mode:
          map['payment_mode'] != null ? map['payment_mode'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistroyModel.fromJson(String source) =>
      HistroyModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
