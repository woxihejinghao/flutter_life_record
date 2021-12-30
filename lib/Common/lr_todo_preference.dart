import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class LRToDoPreference extends HiveObject {
  @HiveField(0)
  bool morningNotice = false; //早晨通知
  @HiveField(1)
  bool noonNotice = false; //中午通知
  @HiveField(2)
  bool nightNotice = false; //晚上通知
}
