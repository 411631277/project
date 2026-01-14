import '../../core/network/api_client.dart';
import 'user_api.dart';
import 'user_question_api.dart';
import 'dour_api.dart';
import 'knowledge_api.dart';
import 'painscale_api.dart';
import 'roommate_api.dart';
import 'sleep_api.dart';
import 'attachment_api.dart';
import 'baby_api.dart';
import 'steps_api.dart';


class Backend3000 {
  Backend3000._();

  static final ApiClient _client =
      ApiClient(baseUrl: 'http://163.13.201.85:3000');

  static final UserApi userApi = UserApi(_client);
  static final UserQuestionApi userQuestionApi = UserQuestionApi(_client);
  static final DourApi dourApi = DourApi(_client);
  static final KnowledgeApi knowledgeApi = KnowledgeApi(_client);
  static final PainScaleApi painScaleApi = PainScaleApi(_client);
  static final RoommateApi roommateApi = RoommateApi(_client);
  static final SleepApi sleepApi = SleepApi(_client);
  static final AttachmentApi attachmentApi = AttachmentApi(_client);
  static final BabyApi babyApi = BabyApi(_client);
  static final StepsApi stepsApi = StepsApi(_client);
}
