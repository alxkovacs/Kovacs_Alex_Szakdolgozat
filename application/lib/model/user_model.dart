import 'package:application/model/user_dto.dart';

class UserModel {
  String? firstName;
  String? email;
  String? password;

  UserModel({this.firstName, this.email});

  factory UserModel.fromUserDTO(UserDTO dto) {
    return UserModel(
      firstName: dto.firstName,
      email: dto.email,
    );
  }

  UserDTO toUserDTO() {
    return UserDTO(
      firstName: firstName,
      email: email,
    );
  }
}
