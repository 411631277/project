import '../../core/network/api_client.dart';

class AttachmentApi {
  final ApiClient _client;
  AttachmentApi(this._client);

  /// POST /attachment
  Future<Map<String, dynamic>> submitAttachment(Map<String, dynamic> payload) {
    return _client.post(
      '/attachment',
      body: payload,
    );
  }
}
