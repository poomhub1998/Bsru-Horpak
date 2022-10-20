// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderModel {
  final String idOrder;
  final String idBuyer;
  final String nameBuyer;
  final String phoneBuyer;
  final String dateOrder;
  final String idOwner;
  final String nameOwner;
  final String phoneOwner;
  final String idProduct;
  final String nameProduct;
  final String priceProduct;
  final String status;
  OrderModel({
    required this.idOrder,
    required this.idBuyer,
    required this.nameBuyer,
    required this.phoneBuyer,
    required this.dateOrder,
    required this.idOwner,
    required this.nameOwner,
    required this.phoneOwner,
    required this.idProduct,
    required this.nameProduct,
    required this.priceProduct,
    required this.status,
  });

  OrderModel copyWith({
    String? idOrder,
    String? idBuyer,
    String? nameBuyer,
    String? phoneBuyer,
    String? dateOrder,
    String? idOwner,
    String? nameOwner,
    String? phoneOwner,
    String? idProduct,
    String? nameProduct,
    String? priceProduct,
    String? status,
  }) {
    return OrderModel(
      idOrder: idOrder ?? this.idOrder,
      idBuyer: idBuyer ?? this.idBuyer,
      nameBuyer: nameBuyer ?? this.nameBuyer,
      phoneBuyer: phoneBuyer ?? this.phoneBuyer,
      dateOrder: dateOrder ?? this.dateOrder,
      idOwner: idOwner ?? this.idOwner,
      nameOwner: nameOwner ?? this.nameOwner,
      phoneOwner: phoneOwner ?? this.phoneOwner,
      idProduct: idProduct ?? this.idProduct,
      nameProduct: nameProduct ?? this.nameProduct,
      priceProduct: priceProduct ?? this.priceProduct,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idOrder': idOrder,
      'idBuyer': idBuyer,
      'nameBuyer': nameBuyer,
      'phoneBuyer': phoneBuyer,
      'dateOrder': dateOrder,
      'idOwner': idOwner,
      'nameOwner': nameOwner,
      'phoneOwner': phoneOwner,
      'idProduct': idProduct,
      'nameProduct': nameProduct,
      'priceProduct': priceProduct,
      'status': status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      idOrder: map['idOrder'] as String,
      idBuyer: map['idBuyer'] as String,
      nameBuyer: map['nameBuyer'] as String,
      phoneBuyer: map['phoneBuyer'] as String,
      dateOrder: map['dateOrder'] as String,
      idOwner: map['idOwner'] as String,
      nameOwner: map['nameOwner'] as String,
      phoneOwner: map['phoneOwner'] as String,
      idProduct: map['idProduct'] as String,
      nameProduct: map['nameProduct'] as String,
      priceProduct: map['priceProduct'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(idOrder: $idOrder, idBuyer: $idBuyer, nameBuyer: $nameBuyer, phoneBuyer: $phoneBuyer, dateOrder: $dateOrder, idOwner: $idOwner, nameOwner: $nameOwner, phoneOwner: $phoneOwner, idProduct: $idProduct, nameProduct: $nameProduct, priceProduct: $priceProduct, status: $status)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.idOrder == idOrder &&
        other.idBuyer == idBuyer &&
        other.nameBuyer == nameBuyer &&
        other.phoneBuyer == phoneBuyer &&
        other.dateOrder == dateOrder &&
        other.idOwner == idOwner &&
        other.nameOwner == nameOwner &&
        other.phoneOwner == phoneOwner &&
        other.idProduct == idProduct &&
        other.nameProduct == nameProduct &&
        other.priceProduct == priceProduct &&
        other.status == status;
  }

  @override
  int get hashCode {
    return idOrder.hashCode ^
        idBuyer.hashCode ^
        nameBuyer.hashCode ^
        phoneBuyer.hashCode ^
        dateOrder.hashCode ^
        idOwner.hashCode ^
        nameOwner.hashCode ^
        phoneOwner.hashCode ^
        idProduct.hashCode ^
        nameProduct.hashCode ^
        priceProduct.hashCode ^
        status.hashCode;
  }
}
