// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SQLiteModel {
  final int? id;
  final String idOwner;
  final String idProduct;
  final String name;
  final String nameOwner;
  final String phone;
  final String price;
  final String lat;
  final String lng;
  SQLiteModel({
    this.id,
    required this.idOwner,
    required this.idProduct,
    required this.name,
    required this.nameOwner,
    required this.phone,
    required this.price,
    required this.lat,
    required this.lng,
  });

  SQLiteModel copyWith({
    int? id,
    String? idOwner,
    String? idProduct,
    String? name,
    String? nameOwner,
    String? phone,
    String? price,
    String? lat,
    String? lng,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      idOwner: idOwner ?? this.idOwner,
      idProduct: idProduct ?? this.idProduct,
      name: name ?? this.name,
      nameOwner: nameOwner ?? this.nameOwner,
      phone: phone ?? this.phone,
      price: price ?? this.price,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idOwner': idOwner,
      'idProduct': idProduct,
      'name': name,
      'nameOwner': nameOwner,
      'phone': phone,
      'price': price,
      'lat': lat,
      'lng': lng,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'] != null ? map['id'] as int : null,
      idOwner: map['idOwner'] as String,
      idProduct: map['idProduct'] as String,
      name: map['name'] as String,
      nameOwner: map['nameOwner'] as String,
      phone: map['phone'] as String,
      price: map['price'] as String,
      lat: map['lat'] as String,
      lng: map['lng'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SQLiteModel(id: $id, idOwner: $idOwner, idProduct: $idProduct, name: $name, nameOwner: $nameOwner, phone: $phone, price: $price, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(covariant SQLiteModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idOwner == idOwner &&
        other.idProduct == idProduct &&
        other.name == name &&
        other.nameOwner == nameOwner &&
        other.phone == phone &&
        other.price == price &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idOwner.hashCode ^
        idProduct.hashCode ^
        name.hashCode ^
        nameOwner.hashCode ^
        phone.hashCode ^
        price.hashCode ^
        lat.hashCode ^
        lng.hashCode;
  }
}
