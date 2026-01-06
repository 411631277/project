import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );

    final res = await _client.get(uri, headers: _headers(headers));
    return _handle(res);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final res = await _client
        .post(uri, headers: _headers(headers), body: jsonEncode(body ?? {}))
        .timeout(const Duration(seconds: 20));

    return _handle(res);
  }

  Map<String, String> _headers(Map<String, String>? extra) => {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        ...?extra,
      };

  Map<String, dynamic> _handle(http.Response res) {
    final text = res.body;
    dynamic decoded;
    try {
      decoded = text.isEmpty ? {} : jsonDecode(text);
    } catch (_) {
      decoded = {'raw': text};
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    }

    // 你可以再加更漂亮的 error class（先用 Exception 落地）
    throw Exception('HTTP ${res.statusCode}: $decoded');
  }

  void dispose() => _client.close();
}
