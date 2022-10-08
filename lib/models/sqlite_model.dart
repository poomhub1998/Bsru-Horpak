// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SQLiteModel {
  final int? id;
  final String idOwner;
  final String idProduct;
  final String name;
  final String phone;
  final String price;
  SQLiteModel({
    this.id,
    required this.idOwner,
    required this.idProduct,
    required this.name,
    required this.phone,
    required this.price,
  });

  SQLiteModel copyWith({
    int? id,
    String? idOwner,
    String? idProduct,
    String? name,
    String? phone,
    String? price,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      idOwner: idOwner ?? this.idOwner,
      idProduct: idProduct ?? this.idProduct,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idOwner': idOwner,
      'idProduct': idProduct,
      'name': name,
      'phone': phone,
      'price': price,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'] != null ? map['id'] as int : null,
      idOwner: map['idOwner'] as String,
      idProduct: map['idProduct'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      price: map['price'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SQLiteModel(id: $id, idOwner: $idOwner, idProduct: $idProduct, name: $name, phone: $phone, price: $price)';
  }

  @override
  bool operator ==(covariant SQLiteModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idOwner == idOwner &&
        other.idProduct == idProduct &&
        other.name == name &&
        other.phone == phone &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idOwner.hashCode ^
        idProduct.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        price.hashCode;
  }
}
