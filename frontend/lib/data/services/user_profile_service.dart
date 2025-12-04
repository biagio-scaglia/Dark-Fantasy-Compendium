import '../models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProfileService {
  static const String _profileKey = 'user_profile';

  Future<UserProfile?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      if (profileJson == null) return null;
      final json = jsonDecode(profileJson) as Map<String, dynamic>;
      return UserProfile.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }

  Future<bool> validatePin(String pin) async {
    final profile = await getProfile();
    if (profile == null || profile.pin == null) return false;
    return profile.pin == pin;
  }
}

