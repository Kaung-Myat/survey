import 'package:hive/hive.dart';
import 'package:survey_app/model/survey_model.dart';
class Boxes{
  static Box<SurveyModel> getSurvey()=> 
    Hive.box<SurveyModel>('SurveyData');
}