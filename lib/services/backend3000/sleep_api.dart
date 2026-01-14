import '../../core/network/api_client.dart';

class SleepApi {
  final ApiClient _client;
  SleepApi(this._client);

  /// POST /sleep
  Future<Map<String, dynamic>> submitSleep(Map<String, dynamic> payload) {
    return _client.post(
      '/sleep',
      body: payload,
    );
  }
}