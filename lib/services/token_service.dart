import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenService {
  static const String _tokenKey = 'auth_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userDataKey = 'user_data';

  // Singleton pattern
  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;
  TokenService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Token'ı 24 saatlik süre ile kaydet
  Future<void> saveToken(String token, {Map<String, dynamic>? userData}) async {
    await init();

    final expiryTime = DateTime.now().add(const Duration(hours: 24));

    await _prefs!.setString(_tokenKey, token);
    await _prefs!.setInt(_tokenExpiryKey, expiryTime.millisecondsSinceEpoch);

    if (userData != null) {
      // User data'yı JSON string olarak kaydet
      final userDataString = jsonEncode(userData);
      await _prefs!.setString(_userDataKey, userDataString);
    }
  }

  // Token'ı al (geçerli ise)
  Future<String?> getToken() async {
    await init();

    final token = _prefs!.getString(_tokenKey);
    if (token == null) return null;

    // Token süresini kontrol et
    final expiryTimestamp = _prefs!.getInt(_tokenExpiryKey);
    if (expiryTimestamp == null) {
      await clearToken(); // Expiry bilgisi yoksa token'ı temizle
      return null;
    }

    final expiryTime = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
    if (DateTime.now().isAfter(expiryTime)) {
      await clearToken(); // Token süresi dolmuş
      return null;
    }

    return token;
  }

  // Token'ın geçerli olup olmadığını kontrol et
  Future<bool> isTokenValid() async {
    final token = await getToken();
    return token != null;
  }

  // User data'yı al
  Future<Map<String, dynamic>?> getUserData() async {
    await init();
    final userDataString = _prefs!.getString(_userDataKey);
    if (userDataString != null) {
      try {
        return jsonDecode(userDataString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Token ve user data'yı temizle
  Future<void> clearToken() async {
    await init();
    await _prefs!.remove(_tokenKey);
    await _prefs!.remove(_tokenExpiryKey);
    await _prefs!.remove(_userDataKey);
  }

  // Logout işlemi
  Future<void> logout() async {
    await clearToken();
  }

  // Token süresini yenile (refresh için)
  Future<void> refreshTokenExpiry() async {
    await init();
    final token = _prefs!.getString(_tokenKey);
    if (token != null) {
      final newExpiryTime = DateTime.now().add(const Duration(hours: 24));
      await _prefs!.setInt(_tokenExpiryKey, newExpiryTime.millisecondsSinceEpoch);
    }
  }
}
