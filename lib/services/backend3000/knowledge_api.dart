import '../../core/network/api_client.dart';

class KnowledgeApi {
  final ApiClient _client;
  KnowledgeApi(this._client);

  /// POST /knowledge
  Future<Map<String, dynamic>> submitKnowledge(Map<String, dynamic> payload) {
    return _client.post(
      '/knowledge',
      body: payload,
    );
  }
}