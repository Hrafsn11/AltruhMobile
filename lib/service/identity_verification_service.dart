import 'dart:convert';
import 'package:dartz/dartz.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_config.dart';
import '../models/identity_verification_model.dart';

class IdentityVerificationService {
  // Admin
  Future<Either<String, List<IdentityVerificationModel>>>
      getIdentityVerifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return const Left('Unauthorized');

      final res = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}:8000/api/admin/identity-verifications/pending'),
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code (getIdentityVerifications): ${res.statusCode}');
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body)['data'];
        final verifications = data
            .map((json) => IdentityVerificationModel.fromJson(json))
            .toList();
        return Right(verifications);
      } else if (res.statusCode == 401) {
        return const Left('Unauthorized');
      } else {
        return const Left('Server Error');
      }
    } catch (e) {
      return const Left('Connection Error');
    }
  }

  Future<Either<String, String>> approveIdentityVerification(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return const Left('Unauthorized');

      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}:8000/api/admin/identity-verifications/$id/approve'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Status Code (approveIdentityVerification): ${response.statusCode}');

      if (response.statusCode == 200) {
        return const Right('Verifikasi berhasil disetujui.');
      } else if (response.statusCode == 401) {
        return const Left('Unauthorized');
      } else {
        return const Left('Server Error');
      }
    } catch (e) {
      return const Left('Connection Error');
    }
  }

  Future<Either<String, String>> rejectIdentityVerification(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return const Left('Unauthorized');

      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}:8000/api/admin/identity-verifications/$id/reject'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code (rejectIdentityVerification): ${response.statusCode}');

      if (response.statusCode == 200) {
        return const Right('Verifikasi berhasil ditolak.');
      } else if (response.statusCode == 401) {
        return const Left('Unauthorized');
      } else {
        return const Left('Server Error');
      }
    } catch (e) {
      return const Left('Connection Error');
    }
  }

  // User
  Future<Either<String, IdentityVerificationModel>>
      getIdentityVerification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return const Left('Unauthorized');

      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}:8000/api/identity-verifications/me'),
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code (getIdentityVerification): ${res.statusCode}');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        final verification = IdentityVerificationModel.fromJson(data);
        return Right(verification);
      } else if (res.statusCode == 401) {
        return const Left('Unauthorized');
      } else {
        return const Left('Server Error');
      }
    } catch (e) {
      return const Left('Connection Error');
    }
  }

  Future<Either<String, String>> createIdentityVerification(
    String name,
    String email,
    String phone,
    String noBank,
    String noKtp,
  ) async {
    try {
      final token = (await SharedPreferences.getInstance()).getString('token');
      if (token == null) return const Left('Unauthorized');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}:8000/api/identity-verifications/raw'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'full_name': name,
          'email': email,
          'phone_number': phone,
          'bank_account_number': noBank,
          'ktp_number': noKtp,
        },
      );

      print('Status Code (createIdentityVerification): ${response.statusCode}');
      print(response.body);
      if (response.statusCode == 201) {
        return const Right('Sukses');
      } else if (response.statusCode == 401) {
        return const Left('Unauthorized');
      } else {
        return const Left('Terjadi Kesalahan');
      }
    } catch (e) {
      return const Left('Connection Error');
    }
  }
}
