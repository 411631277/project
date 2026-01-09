import '../../core/network/api_client.dart';
import 'user_api.dart';

class Backend3000 {
  Backend3000._();

  static final ApiClient _client =
      ApiClient(baseUrl: 'http://163.13.201.85:3000');

  static final UserApi userApi = UserApi(_client);
}
