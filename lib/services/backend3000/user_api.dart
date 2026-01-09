import '../../core/network/api_client.dart';

class UserApi {
  UserApi(this._client);
  final ApiClient _client;

  String _path(bool isManUser) => isManUser ? '/man_users' : '/users';

Future<void> postUser({
  required bool isManUser,
  required Map<String, dynamic> payload,
}) async {
  await _client.post(
    isManUser ? '/man_users' : '/users',
    body: payload,
  );
}

  Future<void> updatePassword({
    required bool isManUser,
    required String userId,
    required String newPassword,
  }) async {
    await _client.post(
      _path(isManUser),
      body: isManUser
          ? {
              'man_user_id': userId,
              'man_user_password': newPassword,
            }
          : {
              'user_id': userId,
              'user_password': newPassword,
            },
    );
  }
}
