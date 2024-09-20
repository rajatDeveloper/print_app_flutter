import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  //  {
  //       "id": 6,
  //       "name": "test_1",
  //       "stock": 1,
  //       "price": "77.00",
  //       "category": "test"
  //   },

  int? id;
  String? name;
  int? stock;
  String? price;
  String? category;

  ProductModel({
    this.id,
    this.name,
    this.stock,
    this.price,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'stock': stock,
      'price': price,
      'category': category,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      stock: map['stock'] != null ? map['stock'] as int : null,
      price: map['price'] != null ? map['price'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
