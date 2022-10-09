// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderModel {
  final String id;
  final String idBuyer;
  final String nameBuyer;
  final String dateOrder;
  final String idOwner;
  final String nameOwner;
  final String idProduct;
  final String nameProduct;
  final String priceProduct;
  final String status;
  OrderModel({
    required this.id,
    required this.idBuyer,
    required this.nameBuyer,
    required this.dateOrder,
    required this.idOwner,
    required this.nameOwner,
    required this.idProduct,
    required this.nameProduct,
    required this.priceProduct,
    required this.status,
  });

  OrderModel copyWith({
    String? id,
    String? idBuyer,
    String? nameBuyer,
    String? dateOrder,
    String? idOwner,
    String? nameOwner,
    String? idProduct,
    String? nameProduct,
    String? priceProduct,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      idBuyer: idBuyer ?? this.idBuyer,
      nameBuyer: nameBuyer ?? this.nameBuyer,
      dateOrder: dateOrder ?? this.dateOrder,
      idOwner: idOwner ?? this.idOwner,
      nameOwner: nameOwner ?? this.nameOwner,
      idProduct: idProduct ?? this.idProduct,
      nameProduct: nameProduct ?? this.nameProduct,
      priceProduct: priceProduct ?? this.priceProduct,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idBuyer': idBuyer,
      'nameBuyer': nameBuyer,
      'dateOrder': dateOrder,
      'idOwner': idOwner,
      'nameOwner': nameOwner,
      'idProduct': idProduct,
      'nameProduct': nameProduct,
      'priceProduct': priceProduct,
      'status': status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      idBuyer: map['idBuyer'] as String,
      nameBuyer: map['nameBuyer'] as String,
      dateOrder: map['dateOrder'] as String,
      idOwner: map['idOwner'] as String,
      nameOwner: map['nameOwner'] as String,
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
    return 'OrderModel(id: $id, idBuyer: $idBuyer, nameBuyer: $nameBuyer, dateOrder: $dateOrder, idOwner: $idOwner, nameOwner: $nameOwner, idProduct: $idProduct, nameProduct: $nameProduct, priceProduct: $priceProduct, status: $status)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idBuyer == idBuyer &&
        other.nameBuyer == nameBuyer &&
        other.dateOrder == dateOrder &&
        other.idOwner == idOwner &&
        other.nameOwner == nameOwner &&
        other.idProduct == idProduct &&
        other.nameProduct == nameProduct &&
        other.priceProduct == priceProduct &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idBuyer.hashCode ^
        nameBuyer.hashCode ^
        dateOrder.hashCode ^
        idOwner.hashCode ^
        nameOwner.hashCode ^
        idProduct.hashCode ^
        nameProduct.hashCode ^
        priceProduct.hashCode ^
        status.hashCode;
  }
}
