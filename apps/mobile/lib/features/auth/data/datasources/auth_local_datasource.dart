import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/auth_user.dart';
import '../models/auth_user_model.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final Box _hiveBox;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _userKey = 'auth_user';

  AuthLocalDataSource(this._secureStorage, this._hiveBox);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> saveUser(AuthUser user) async {
    final model = AuthUserModel.fromEntity(user);
    await _hiveBox.put(_userKey, model.toJson());
  }

  Future<AuthUser?> getUser() async {
    final json = _hiveBox.get(_userKey) as Map<dynamic, dynamic>?;
    if (json == null) return null;
    return AuthUserModel.fromJson(
      json.cast<String, dynamic>(),
    ).toEntity();
  }

  Future<void> clearAll() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _hiveBox.delete(_userKey);
  }

  Future<bool> hasSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
