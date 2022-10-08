// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  final String id;
  final String idOwner;
  final String nameOwner;
  final String name;
  final String phone;
  final String price;
  final String detail;
  final String address;
  final String lat;
  final String lng;
  final String images;
  ProductModel({
    required this.id,
    required this.idOwner,
    required this.nameOwner,
    required this.name,
    required this.phone,
    required this.price,
    required this.detail,
    required this.address,
    required this.lat,
    required this.lng,
    required this.images,
  });

  ProductModel copyWith({
    String? id,
    String? idOwner,
    String? nameOwner,
    String? name,
    String? phone,
    String? price,
    String? detail,
    String? address,
    String? lat,
    String? lng,
    String? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      idOwner: idOwner ?? this.idOwner,
      nameOwner: nameOwner ?? this.nameOwner,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      price: price ?? this.price,
      detail: detail ?? this.detail,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idOwner': idOwner,
      'nameOwner': nameOwner,
      'name': name,
      'phone': phone,
      'price': price,
      'detail': detail,
      'address': address,
      'lat': lat,
      'lng': lng,
      'images': images,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      idOwner: map['idOwner'] as String,
      nameOwner: map['nameOwner'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      price: map['price'] as String,
      detail: map['detail'] as String,
      address: map['address'] as String,
      lat: map['lat'] as String,
      lng: map['lng'] as String,
      images: map['images'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, idOwner: $idOwner, nameOwner: $nameOwner, name: $name, phone: $phone, price: $price, detail: $detail, address: $address, lat: $lat, lng: $lng, images: $images)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idOwner == idOwner &&
        other.nameOwner == nameOwner &&
        other.name == name &&
        other.phone == phone &&
        other.price == price &&
        other.detail == detail &&
        other.address == address &&
        other.lat == lat &&
        other.lng == lng &&
        other.images == images;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idOwner.hashCode ^
        nameOwner.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        price.hashCode ^
        detail.hashCode ^
        address.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        images.hashCode;
  }
}
