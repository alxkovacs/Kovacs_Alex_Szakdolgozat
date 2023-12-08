class UserDTO {
  String? firstName;
  String? email;
  String? password;

  UserDTO({this.firstName, this.email, this.password});

  factory UserDTO.fromFirebaseJson(Map<String, dynamic> json) {
    return UserDTO(
      firstName: json['firstname'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'firstname': firstName ?? '',
      'email': email ?? '',
      'password': password ?? '',
    };
  }
}
