import 'package:hive/hive.dart';

part 'setting_model.g.dart';

@HiveType(typeId: 1)
class SettingModel extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  SettingModel({required this.isDarkMode});
}
