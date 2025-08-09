import 'package:nfc/features/home/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.name, required super.balance});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'balance': balance};
  }
}
