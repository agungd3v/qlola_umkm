import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalLogger {
  static const String _storageKey = 'global_logs';

  static Future<void> _addLog(String tag, String type, String message) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();

    final newLog = {
      "timestamp": now,
      "tag": tag,
      "type": type,
      "message": message,
    };

    final logsRaw = prefs.getString(_storageKey);
    List<dynamic> logs = logsRaw != null ? json.decode(logsRaw) : [];

    logs.insert(0, newLog);
    if (logs.length > 100) logs = logs.sublist(0, 100);

    await prefs.setString(_storageKey, json.encode(logs));
  }

  static Future<void> logPrinter(String type, String message) async {
    await _addLog("printer", type, message);
  }

  static Future<void> logAuth(String type, String message) async {
    await _addLog("auth", type, message);
  }

  static Future<void> logTransaction(String type, String message) async {
    await _addLog("transaction", type, message);
  }

  static Future<void> logGeneral(String type, String message) async {
    await _addLog("general", type, message);
  }

  static Future<List<Map<String, dynamic>>> getLogs({String? tag}) async {
    final prefs = await SharedPreferences.getInstance();
    final logsRaw = prefs.getString(_storageKey);
    List<dynamic> logs = logsRaw != null ? json.decode(logsRaw) : [];

    if (tag != null) {
      logs = logs.where((log) => log['tag'] == tag).toList();
    }

    return List<Map<String, dynamic>>.from(logs);
  }

  static Future<void> clearLogs({String? tag}) async {
    final prefs = await SharedPreferences.getInstance();
    final logsRaw = prefs.getString(_storageKey);
    List<dynamic> logs = logsRaw != null ? json.decode(logsRaw) : [];

    if (tag == null) {
      await prefs.remove(_storageKey);
    } else {
      logs = logs.where((log) => log['tag'] != tag).toList();
      await prefs.setString(_storageKey, json.encode(logs));
    }
  }
}
