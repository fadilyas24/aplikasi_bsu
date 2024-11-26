import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityLogHelper {
  static const String activityLogKey = 'activity_log';

  // Menyimpan log aktivitas
  static Future<void> saveLog(String productName, int pointsUsed) async {
    final prefs = await SharedPreferences.getInstance();
    final currentLogs = await getLogs();

    final newLog = {
      'productName': productName,
      'pointsUsed': pointsUsed,
      'date': DateTime.now().toIso8601String(),
    };

    currentLogs.add(newLog);
    await prefs.setString(activityLogKey, jsonEncode(currentLogs));
  }

  // Mengambil semua log aktivitas
  static Future<List<Map<String, dynamic>>> getLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsString = prefs.getString(activityLogKey);
    if (logsString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(logsString));
    }
    return [];
  }
}
