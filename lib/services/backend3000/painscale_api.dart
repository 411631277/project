import '../../core/network/api_client.dart';

class PainScaleApi {
  final ApiClient _client;
  PainScaleApi(this._client);

  /// POST /painscale
  Future<Map<String, dynamic>> submitPainScale(Map<String, dynamic> payload) {
    return _client.post(
      '/painscale',
      body: payload,
    );
  }
}