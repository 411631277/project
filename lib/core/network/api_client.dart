import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _buildUri(String path, {Map<String, String>? queryParameters}) {
    // 保證不會出現 baseUrl 結尾/ path 開頭多一個或少一個 /
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$normalizedBase$normalizedPath');

    if (queryParameters == null || queryParameters.isEmpty) return uri;
    return uri.replace(queryParameters: queryParameters);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters: queryParameters);

    final res = await _client.get(
      uri,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        ...?headers,
      },
    );

    dynamic decoded;
    try {
      decoded = res.body.isEmpty ? {} : jsonDecode(res.body);
    } catch (_) {
      decoded = {'raw': res.body};
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    }

    throw Exception('HTTP ${res.statusCode}: $decoded');
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path);

    final res = await _client.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        HttpHeaders.acceptHeader: 'application/json',
        ...?headers,
      },
      body: jsonEncode(body ?? {}),
    );

    dynamic decoded;
    try {
      decoded = res.body.isEmpty ? {} : jsonDecode(res.body);
    } catch (_) {
      decoded = {'raw': res.body};
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    }

    throw Exception('HTTP ${res.statusCode}: $decoded');
  }

  void dispose() => _client.close();
}
