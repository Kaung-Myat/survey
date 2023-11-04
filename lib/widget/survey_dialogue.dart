// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:survey_app/model/survey_model.dart';

class SurveyDialogue extends StatefulWidget {
  final SurveyModel? surveyModel;
  final Function(String name,int age,int phoneNumber,String address,int familyMembers,int gender,String additional) onClickDone;

  const SurveyDialogue({
    super.key,
    this.surveyModel,
    required this.onClickDone
  });

  @override
  State<SurveyDialogue> createState() => _SurveyDialogueState();
}

class _SurveyDialogueState extends State<SurveyDialogue> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final familyMembersController = TextEditingController();
  final additionalController = TextEditingController();

  int gender = 0;

  @override
  void initState(){
    super.initState();
    if(widget.surveyModel != null){
      final surveyModel = widget.surveyModel!;

      nameController.text = surveyModel.name;
      ageController.text = surveyModel.age.toString();
      phoneNumberController.text = surveyModel.phoneNumber.toString();
      addressController.text = surveyModel.address;
      familyMembersController.text = surveyModel.familyMembers.toString();
      additionalController.text = surveyModel.additional.toString();
      gender = surveyModel.gender;
    }
  }

  @override
  void dispose(){
      nameController.dispose();
      ageController.dispose();
      phoneNumberController.dispose();
      addressController.dispose();
      familyMembersController.dispose();
      additionalController.dispose();

      super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.surveyModel != null;
    final title = isEditing?'Edit Informations' : 'Add Informations';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
                    // Add your scrollable content here
                    SizedBox(height: 12,),
                    buildName(),
                    SizedBox(height: 12,),
                    buildAge(),
                    SizedBox(height: 12,),
                    buildPhoneNumber(),
                    SizedBox(height: 12,),
                    buildAddress(),
                    SizedBox(height: 12,),
                    buildFamilyMember(),
                    SizedBox(height: 12,),
                    buildAdditional(),
                    SizedBox(height: 12,),
                    buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions:<Widget> [
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing)
      ],
    );
  }

  //widget for 'Name' textFormField
  Widget buildName()=> TextFormField(
    controller: nameController,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: 'Enter Name',
    ),
    validator: (name)=>
        name != null && name.isEmpty ? 'Enter a name':null,
  );

  //widget for 'age' textFormField
  Widget buildAge()=> TextFormField(
    controller: ageController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: 'Enter Age'
    ),
    validator: (age)=> age != null && int.tryParse(age)==null 
      ?'Enter an age'
      : null,
  );

  //widget for 'phone number' textformfield
  Widget buildPhoneNumber()=> TextFormField(
    controller: phoneNumberController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: 'Enter Phone Number'
    ),
    validator: (phoneNum)=> phoneNum != null && int.tryParse(phoneNum)==null
      ?'Enter a phone number'
      : null,
  );

  //widget for 'address' textformfield
  Widget buildAddress()=> TextFormField(
    controller: addressController,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: 'Enter Address'
    ),
    validator: (address)=> address != null && address.isEmpty
      ?'Enter an address'
      : null,
  );

  //widget for 'family memeber' textFormField
  Widget buildFamilyMember()=> TextFormField(
    controller: familyMembersController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: 'Enter Family Member'
    ),
    validator: (familyMemeber)=> familyMemeber != null && int.tryParse(familyMemeber)==null
      ?'Enter a family member'
      : null,
  );

  //widget for 'additional' textformfield
  Widget buildAdditional()=> TextFormField(
    controller: additionalController,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: 'Enter General Info'
    ),
  );

  //widget for 'gender' radio buttons
  Widget buildRadioButtons()=> Column(
    children: [
      RadioListTile<int>(
        title: Text("Gay"),
        value: 0,
        groupValue: gender, 
        onChanged: (value)=>setState(() => gender = value!),
      ),
      RadioListTile<int>(
        title: Text("Lesbian"),
        value: 1,
        groupValue: gender, 
        onChanged: (value)=>setState(() => gender = value!),
      ),
      RadioListTile<int>(
        title: Text("Bisexual"),
        value: 2,
        groupValue: gender, 
        onChanged: (value)=>setState(() => gender = value!),
      ),
      RadioListTile<int>(
        title: Text("Queer/Questioning"),
        value: 3,
        groupValue: gender, 
        onChanged: (value)=>setState(() => gender = value!),
      ),
      RadioListTile<int>(
        title: Text("Transgender"),
        value: 4,
        groupValue: gender, 
        onChanged: (value)=>setState(() => gender = value!),
      ),
      RadioListTile<int>(
        title: Text("Others"),
        value: 5,
        groupValue: gender, 
        onChanged: (value)=>setState(() => gender = value!),
      ),
    ],
  );

  //widget for cancel button
  Widget buildCancelButton(BuildContext context) => TextButton(
    child: Text("Cancel"),
    onPressed: ()=>Navigator.of(context).pop(),
  );

  //widget for add button
  Widget buildAddButton(BuildContext context,{required bool isEditing}){
    final text = isEditing?'Save':'Add';
    return TextButton(
      child: Text(text),
      onPressed: ()async{
          final isValid = formKey.currentState!.validate();
          if(isValid){
            final name = nameController.text;
            final age = int.tryParse(ageController.text) ?? 0;
            final phoneNumber = int.tryParse(phoneNumberController.text)??0;
            final address = addressController.text;
            final familyMembers = int.tryParse(familyMembersController.text)??0;
            final additional = additionalController.text;
            if(age >= 100 || familyMembers >= 100){
                _showAlertDialog(context);
            }else{
              
              widget.onClickDone(name,age,phoneNumber,address,familyMembers,gender,additional);

              Navigator.of(context).pop();
            }
          }
      }, 
    );
  }

  void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert!',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
        content: Text('Age and Family members are above 100.'),
        actions: [
          // You can add buttons to perform actions
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

} 