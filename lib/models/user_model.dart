// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String user;
  final String password;
  final String name;
  final String address;
  final String phone;
  final String type;
  final String avatar;
  final String lat;
  final String lng;
  UserModel({
    required this.id,
    required this.user,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
    required this.type,
    required this.avatar,
    required this.lat,
    required this.lng,
  });

  UserModel copyWith({
    String? id,
    String? user,
    String? password,
    String? name,
    String? address,
    String? phone,
    String? type,
    String? avatar,
    String? lat,
    String? lng,
  }) {
    return UserModel(
      id: id ?? this.id,
      user: user ?? this.user,
      password: password ?? this.password,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      avatar: avatar ?? this.avatar,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'password': password,
      'name': name,
      'address': address,
      'phone': phone,
      'type': type,
      'avatar': avatar,
      'lat': lat,
      'lng': lng,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      user: map['user'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      type: map['type'] as String,
      avatar: map['avatar'] as String,
      lat: map['lat'] as String,
      lng: map['lng'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, user: $user, password: $password, name: $name, address: $address, phone: $phone, type: $type, avatar: $avatar, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.password == password &&
        other.name == name &&
        other.address == address &&
        other.phone == phone &&
        other.type == type &&
        other.avatar == avatar &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        password.hashCode ^
        name.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        type.hashCode ^
        avatar.hashCode ^
        lat.hashCode ^
        lng.hashCode;
  }
}
