class IdentityVerificationModel {
  final int id;
  final int userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String bankAccountNumber;
  final String ktpNumber;
  final String photo;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  IdentityVerificationModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.bankAccountNumber,
    required this.ktpNumber,
    required this.photo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IdentityVerificationModel.fromJson(Map<String, dynamic> json) {
    return IdentityVerificationModel(
      id: json['id'],
      userId: json['user_id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      bankAccountNumber: json['bank_account_number'],
      ktpNumber: json['ktp_number'],
      photo: json['photo'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
