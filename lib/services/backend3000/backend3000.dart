import '../../core/network/api_client.dart';
import 'user_api.dart';

// 之後有 steps_api / baby_api 再加

class Backend3000 {
  Backend3000._(); // 不讓被 new

  static final ApiClient _client =
      ApiClient(baseUrl: 'http://163.13.201.85:3000');

  static final UserApi userApi = UserApi(_client);
  
}
