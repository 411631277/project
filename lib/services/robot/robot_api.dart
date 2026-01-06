// lib/services/robot/robot_api.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RobotApi {
  RobotApi({
    http.Client? client,
    this.apiUrl = 'http://163.13.202.126:8000/query',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String apiUrl;

  /// 回傳「逐段文字」(chunk) 的 Stream
  /// 後端格式：SSE line: "data: {...json...}"，json 內有 data 欄位；結束用 [DONE]
  Stream<String> queryStream({
    required String message,
    required String userId,
    required bool isManUser,
  }) async* {
    final request = http.Request('POST', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'application/json; charset=utf-8';
    request.body = jsonEncode({
      'message': message,
      'user_id': userId,
      'is_man_user': isManUser,
    });

    final response = await _client.send(request);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final errText = await response.stream.bytesToString();
      throw Exception('Robot API HTTP ${response.statusCode}: $errText');
    }

    // SSE 常見做法：用 LineSplitter 拆行
    await for (final line in response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      if (!line.startsWith('data: ')) continue;

      final payload = line.substring('data: '.length).trim();
      if (payload == '[DONE]') break;

      // 你的後端 payload 是 JSON，且 chunk 放在 data 欄位
      try {
        final obj = jsonDecode(payload);
        if (obj is Map<String, dynamic>) {
          final chunk = (obj['data'] ?? '').toString();
          if (chunk.isNotEmpty) yield chunk;
        }
      } catch (_) {
        // 若偶發不是 JSON，就直接丟回文字（保底）
        if (payload.isNotEmpty) yield payload;
      }
    }
  }

  void dispose() => _client.close();
}
