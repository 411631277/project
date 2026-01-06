import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class UserApi {
  UserApi(this._client);
  final ApiClient _client;

  String _path(bool isManUser) =>
      isManUser ? ApiEndpoints.manUsers : ApiEndpoints.users;

  Future<Map<String, dynamic>> postUser({
    required bool isManUser,
    required Map<String, dynamic> payload,
  }) {
    return _client.post(_path(isManUser), body: payload);
  }

  Future<Map<String, dynamic>> updatePassword({
    required bool isManUser,
    required String userId,
    required String newPassword,
  }) {
    return postUser(
      isManUser: isManUser,
      payload: isManUser
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