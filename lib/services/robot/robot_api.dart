import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RobotApi {
  RobotApi({
    http.Client? client,
    this.apiUrl = 'http://163.13.202.126:8000/query',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String apiUrl;

  /// SSE: line = "data: {...json...}"，json 內 chunk 在 data 欄位，結束為 [DONE]
  Stream<String> queryStream({
    required String message,
    required String userId,
    required bool isManUser,
  }) async* {
    try {
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

      await for (final line in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (!line.startsWith('data: ')) continue;

        final payload = line.substring('data: '.length).trim();
        if (payload == '[DONE]') return;

        try {
          final obj = jsonDecode(payload);
          if (obj is Map<String, dynamic>) {
            final chunk = (obj['data'] ?? '').toString();
            if (chunk.isNotEmpty) yield chunk;
          }
        } catch (_) {
          // 保底：偶發不是 JSON 就直接當文字
          if (payload.isNotEmpty) yield payload;
        }
      }
    } on http.ClientException catch (_) {
      // 連線中途關閉（使用者離開/取消/後端斷線）
      // 這裡選擇「安靜結束」，避免噴紅
      return;
    } on SocketException catch (e) {
      throw Exception('網路連線失敗：${e.message}');
    } on TimeoutException {
      throw Exception('連線逾時，請稍後再試');
    }
  }

  void dispose() => _client.close();
}
