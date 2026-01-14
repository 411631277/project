import '../../core/network/api_client.dart';

class StepsApi {
  final ApiClient _client;
  StepsApi(this._client);

  /// GET /steps?user_id=...
  Future<Map<String, dynamic>> fetchStepsHistory({required String userId}) {
    return _client.get(
      '/steps',
      queryParameters: {'user_id': userId},
    );
  }

  /// POST /steps
  Future<Map<String, dynamic>> submitSteps(Map<String, dynamic> payload) {
    return _client.post('/steps', body: payload);
  }
}