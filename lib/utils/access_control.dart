import 'package:shared_preferences/shared_preferences.dart';

class AccessControl {

  /// True if user is owner OR has "Admin Role"
  static Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final isOwner = prefs.getBool('is_owner') ?? false;
    if (isOwner) return true;

    // Also treat users with "Admin Role" as admin
    final roles = prefs.getStringList('roles') ?? [];
    return roles.contains('Admin Role');
  }

  static Future<bool> hasRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getStringList('roles') ?? [];
    return roles.contains(role);
  }

  static Future<bool> hasPermission(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final permissions = prefs.getStringList('permission_codes') ?? [];
    return permissions.contains(code);
  }

  /// Convenience: true if admin OR has the given permission
  static Future<bool> canDo(String permissionCode) async {
    if (await isAdmin()) return true;
    return hasPermission(permissionCode);
  }
}