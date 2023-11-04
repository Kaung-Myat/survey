// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:survey_app/boxes.dart';
import 'package:survey_app/model/survey_model.dart';
import 'package:survey_app/utils/exportCSV.dart';
import 'package:survey_app/widget/survey_dialogue.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.black,
          title:const Center(child:Text("Survey",style: TextStyle(fontSize: 25),)),
        ),
        body: ValueListenableBuilder(
          valueListenable: Boxes.getSurvey().listenable(), 
          builder: (context,box,_){
              final surveys = box.values.toList().cast<SurveyModel>();
              return buildContent(surveys);
          }
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: ()=> showDialog(
            context:context, 
            builder: (context)=>SurveyDialogue(
              onClickDone: addSurvey,
            )
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child:SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: 40,
                          onPressed: (){
                              List<SurveyModel> surveyModel = Boxes.getSurvey().values.toList();
                              
                              exportToExcel(context,surveyModel);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.list
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
  Widget buildContent(List<SurveyModel> surveyModel){
    if(surveyModel.isEmpty){
      return Center(
        child: Text(
          'No Survey yet!',
          style: TextStyle(fontSize: 14),
        ),
      );
    }else{
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: surveyModel.length,
                itemBuilder: (BuildContext context,int i){
                  final survey = surveyModel[i];

                  return buildSurvey(context,survey);
                },
              ),
            )
          ],
        );
    }
  }

  Widget buildSurvey(
    BuildContext context,
    SurveyModel survey,
  ){
    final date = DateFormat.yMMMd().format(survey.createdDate);
    String gender = "";
    if(survey.gender == 0){
      gender += "Gay";
    }else if(survey.gender == 1){
      gender += "Lesbian";
    }else if(survey.gender == 2){
      gender += "Bisexual";
    }else if(survey.gender == 3){
      gender += "Queer/Questioning";
    }else if(survey.gender == 4){
      gender += "Transgender";
    }else if(survey.gender == 5){
      gender += "Others";
    }
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          survey.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
        ),
        subtitle: Text(date),
        trailing: Text(
          gender,
          style: TextStyle(
            fontWeight: FontWeight.bold,fontSize: 16
          ),
        ),
        children: [
          buildButtons(context, survey),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context,SurveyModel survey)=>Row(
    children: [
      Expanded(
        child: TextButton.icon(
          label: Text("Edit"),
          icon: Icon(Icons.edit,color: Colors.black,),
          onPressed: ()=>Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context)=>SurveyDialogue(
                surveyModel: survey,
                onClickDone:(name, age, phoneNumber, address, familyMembers, gender, additional) =>  
                    editSurvey(survey, name, age, phoneNumber, address, familyMembers, gender, additional),
              )
            )
          ),
        ),
      ),
      Expanded(
        child: TextButton.icon(
            label: Text("Delete"),
            icon: Icon(Icons.delete,color: Colors.black,), 
            onPressed: ()=>deleteSurvey(survey),
        ),
      )
    ],
  );

  Future addSurvey(String name,int age,int phoneNumber,String address,int familyMembers,int gender,String additional) async{
    final survey = SurveyModel(
      name : name,
      age : age,
      phoneNumber : phoneNumber,
      address : address,
      familyMembers : familyMembers,
      gender : gender,
      additional : additional,
      createdDate : DateTime.now()
    );
      

    final box = Boxes.getSurvey();
    box.add(survey);
  }

  void editSurvey(
    SurveyModel survey,
    String name,
    int age,
    int phoneNumber,
    String address,
    int familyMembers,
    int gender,
    String additional
  ){
    survey.name = name;
    survey.age = age;
    survey.phoneNumber = phoneNumber;
    survey.address = address;
    survey.familyMembers = familyMembers;
    survey.gender = gender;
    survey.additional = additional;

    survey.save();
  }

  void deleteSurvey(SurveyModel survey){
      survey.delete();
  }
}