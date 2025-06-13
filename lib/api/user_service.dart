import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userClinicNameKey = 'userClinicName'; //aa

  static const String _userAddressKey = 'user_address';
  static const String _userRoleKey = 'user_role'; // Add role key

  // Add these two methods
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Keep your existing methods
  static Future<bool> saveUserData({
    required String userId,
    String? username,
    String? email,
    String? clinicName,
    String? address,
    String? role,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(_userIdKey, userId),
        if (username != null) prefs.setString(_userNameKey, username),
        if (email != null) prefs.setString(_userEmailKey, email),
        if (clinicName != null) prefs.setString(_userClinicNameKey, clinicName),
        if (address != null) prefs.setString(_userAddressKey, address),
        if (role != null) prefs.setString(_userRoleKey, role),  // Save role
      ]);
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  static Future<String?> getUserAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userAddressKey);
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> logout() async {
    try {
      // 1. Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // 2. Clear local data
      await clearAllData();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  static Future<String?> getUserClinicName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userClinicNameKey);
    } catch (e) {
      print('Error getting clinic name: $e');
      return null;
    }
  }

  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_userIdKey),
        prefs.remove(_userNameKey),
        prefs.remove(_userEmailKey),
        prefs.remove(_userClinicNameKey),
        prefs.remove(_userAddressKey),
        prefs.remove(_userRoleKey),
      ]);
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  // Add this new method
  static Future<bool> isLoggedIn() async {
    try {
      // Check Firebase auth state
      final firebaseUser = FirebaseAuth.instance.currentUser;
      
      // Check local storage
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);
      
      // User is logged in if either Firebase or local auth is valid
      return firebaseUser != null || (userId != null && userId.isNotEmpty);
    } catch (e) {
      print('Error checking login state: $e');
      return false;
    }
  }

  // Add this new method
  static Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userRoleKey);
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
}
