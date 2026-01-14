import '../../core/network/api_client.dart';

class BabyApi {
  final ApiClient _client;
  BabyApi(this._client);

  /// POST /baby
  Future<Map<String, dynamic>> submitBaby(Map<String, dynamic> payload) {
    return _client.post('/baby', body: payload);
  }
}