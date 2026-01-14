import '../../core/network/api_client.dart';

class DourApi {
  final ApiClient _client;
  DourApi(this._client);

  /// POST /dour
  Future<Map<String, dynamic>> submitDour(Map<String, dynamic> payload) {
    return _client.post(
      '/dour',
      body: payload,
    );
  }
}