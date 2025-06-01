class UserModel {
  int id;
  String name;
  String email;
  String password;
  String phone;
  String? photo;
  String role;

  UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
    this.photo,
    required this.role,
  });
}
