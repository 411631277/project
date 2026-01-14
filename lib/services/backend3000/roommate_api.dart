import '../../core/network/api_client.dart';

class RoommateApi {
  final ApiClient _client;
  RoommateApi(this._client);

  /// POST /roommate
  Future<Map<String, dynamic>> submitRoommate(Map<String, dynamic> payload) {
    return _client.post(
      '/roommate',
      body: payload,
    );
  }
}