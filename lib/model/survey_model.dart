import 'package:hive/hive.dart';

part 'survey_model.g.dart';

@HiveType(typeId: 0)
class SurveyModel extends HiveObject{
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int age;

  @HiveField(2)
  late int phoneNumber;

  @HiveField(3)
  late String address;

  @HiveField(4)
  late int familyMembers;

  @HiveField(5)
  late int gender=0;

  @HiveField(6)
  late String additional;

  @HiveField(7)
  late DateTime createdDate;

  SurveyModel({
    required this.name,
    required this.age,
    required this.phoneNumber,
    required this.additional,
    required this.address,
    required this.createdDate,
    required this.familyMembers,
    required this.gender
  });
}
