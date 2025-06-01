import 'package:donasi_app/models/user_model.dart';

class IdentityVerificationModel {
  int id;
  UserModel user;
  String ktpNumber;
  String photo;
  String status;

  IdentityVerificationModel({
    required this.id,
    required this.user,
    required this.ktpNumber,
    required this.photo,
    required this.status,
  });
}
