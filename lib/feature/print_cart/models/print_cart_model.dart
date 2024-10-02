// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:print_app/feature/print_cart/models/product_model.dart';

class PrintCartModel {
  // "id": 12,
  //       "product": {
  //           "id": 6,
  //           "name": "test_1",
  //           "stock": 1,
  //           "price": "77.00",
  //           "category": "test"
  //       },
  //       "quantity": 2,
  //       "isInCart": true

  int? id;
  ProductModel? product;
  int? quantity;
  bool? isInCart;
  PrintCartModel({
    this.id,
    this.product,
    this.quantity,
    this.isInCart,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product?.toMap(),
      'quantity': quantity,
      'isInCart': isInCart,
    };
  }

  factory PrintCartModel.fromMap(Map<String, dynamic> map) {
    return PrintCartModel(
      id: map['id'] != null ? map['id'] as int : null,
      product: map['product'] != null
          ? ProductModel.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      isInCart: map['isInCart'] != null ? map['isInCart'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrintCartModel.fromJson(String source) =>
      PrintCartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
