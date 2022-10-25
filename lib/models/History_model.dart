// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HistoryModel {
  final String id;
  final String idBuyer;
  final String nameBuyer;
  final String phoneBuyer;
  final String idOwner;
  final String nameOwner;
  final String phoneOwner;
  final String nameProduct;
  final String dateOrder;
  HistoryModel({
    required this.id,
    required this.idBuyer,
    required this.nameBuyer,
    required this.phoneBuyer,
    required this.idOwner,
    required this.nameOwner,
    required this.phoneOwner,
    required this.nameProduct,
    required this.dateOrder,
  });

  HistoryModel copyWith({
    String? id,
    String? idBuyer,
    String? nameBuyer,
    String? phoneBuyer,
    String? idOwner,
    String? nameOwner,
    String? phoneOwner,
    String? nameProduct,
    String? dateOrder,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      idBuyer: idBuyer ?? this.idBuyer,
      nameBuyer: nameBuyer ?? this.nameBuyer,
      phoneBuyer: phoneBuyer ?? this.phoneBuyer,
      idOwner: idOwner ?? this.idOwner,
      nameOwner: nameOwner ?? this.nameOwner,
      phoneOwner: phoneOwner ?? this.phoneOwner,
      nameProduct: nameProduct ?? this.nameProduct,
      dateOrder: dateOrder ?? this.dateOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idBuyer': idBuyer,
      'nameBuyer': nameBuyer,
      'phoneBuyer': phoneBuyer,
      'idOwner': idOwner,
      'nameOwner': nameOwner,
      'phoneOwner': phoneOwner,
      'nameProduct': nameProduct,
      'dateOrder': dateOrder,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'] as String,
      idBuyer: map['idBuyer'] as String,
      nameBuyer: map['nameBuyer'] as String,
      phoneBuyer: map['phoneBuyer'] as String,
      idOwner: map['idOwner'] as String,
      nameOwner: map['nameOwner'] as String,
      phoneOwner: map['phoneOwner'] as String,
      nameProduct: map['nameProduct'] as String,
      dateOrder: map['dateOrder'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) =>
      HistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoryModel(id: $id, idBuyer: $idBuyer, nameBuyer: $nameBuyer, phoneBuyer: $phoneBuyer, idOwner: $idOwner, nameOwner: $nameOwner, phoneOwner: $phoneOwner, nameProduct: $nameProduct, dateOrder: $dateOrder)';
  }

  @override
  bool operator ==(covariant HistoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idBuyer == idBuyer &&
        other.nameBuyer == nameBuyer &&
        other.phoneBuyer == phoneBuyer &&
        other.idOwner == idOwner &&
        other.nameOwner == nameOwner &&
        other.phoneOwner == phoneOwner &&
        other.nameProduct == nameProduct &&
        other.dateOrder == dateOrder;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idBuyer.hashCode ^
        nameBuyer.hashCode ^
        phoneBuyer.hashCode ^
        idOwner.hashCode ^
        nameOwner.hashCode ^
        phoneOwner.hashCode ^
        nameProduct.hashCode ^
        dateOrder.hashCode;
  }
}
