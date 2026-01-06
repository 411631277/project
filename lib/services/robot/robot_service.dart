import 'dart:async';
import 'robot_api.dart';

class RobotService {
  RobotService(this._api);
  final RobotApi _api;

  /// 回傳整段回答（內部仍然用 SSE chunk 累積）
  Future<String> askOnce({
    required String message,
    required String userId,
    required bool isManUser,
    void Function(String chunk)? onChunk,
  }) async {
    final buffer = StringBuffer();

    await for (final chunk in _api.queryStream(
      message: message,
      userId: userId,
      isManUser: isManUser,
    )) {
      buffer.write(chunk);
      onChunk?.call(chunk);
    }

    return buffer.toString();
  }
}
