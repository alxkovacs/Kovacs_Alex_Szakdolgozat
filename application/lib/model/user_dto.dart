class UserDTO {
  String? firstName;
  String? email;

  UserDTO({this.firstName, this.email});

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
    };
  }
}
