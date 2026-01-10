import '../../core/network/api_client.dart';

class UserQuestionApi {
  UserQuestionApi(this._client);
  final ApiClient _client;

  /// Update / insert user questionnaire fields to MySQL.
  /// Backend endpoint: POST /user_question
  Future<void> updateUserQuestion({
    required int userId,
    required Map<String, dynamic> fields,
  }) async {
    final payload = <String, dynamic>{
      'user_id': userId,
      ...fields,
    };

    await _client.post('/user_question', body: payload);
  }
}
