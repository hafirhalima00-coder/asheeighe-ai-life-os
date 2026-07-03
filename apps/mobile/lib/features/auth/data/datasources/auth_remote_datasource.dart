import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _apiClient.post(ApiConstants.logout);
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiConstants.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> sendPasswordReset(String email) async {
    await _apiClient.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }

  Future<AuthResponse> signInWithGoogle(String idToken) async {
    final response = await _apiClient.post(
      ApiConstants.googleSignIn,
      data: {'idToken': idToken},
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> signInWithApple(Map<String, dynamic> appleCredential) async {
    final response = await _apiClient.post(
      ApiConstants.appleSignIn,
      data: appleCredential,
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
