import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/services/repository.dart';
import 'package:random_string/random_string.dart';
import 'package:file_picker/file_picker.dart';

class NoteForm extends StatefulWidget
{
  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();
  String course;
  String subject;
  String sem;
  String module;
  String topic;
  String file;
  bool isLoading = false;
  String notesId;

  List<String> _subjects=[];
  List<String> _semesters=[];
  static const List<String> _modules =['1', '2', '3', '4', '5','6'];
  static const List<String> _courses =['Civil Engineering', 'Computer Science & Engineering', 'All'];

  Repository repo = Repository();

  @override
  void initState() {
    _semesters = List.from(_semesters)..addAll(repo.getSemesterscse());
    super.initState();
  }

  uploadNotes(){

    notesId = randomAlphaNumeric(16);
    if(_formKey.currentState.validate()){

      setState(() {
        isLoading = true;
      });

      Map<String, String> notesData = {
        "course" : course,
        "module" :module,
        "sem":sem,
        "subject":subject,
        "topic":topic,
        "notesId":notesId,
        "file":""
      };
      //addNotesData(Map notesData, String notesId)
      databaseService.addNotesData(notesData, notesId).then((value) {
        setState(() {
          isLoading = false;
          _showDialogue(context);
        });
      });
      getPdfAndUpload(notesId);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Note"),
        centerTitle: true,
        elevation: 0.8,
      ),
      body: Builder(
          builder: (context) =>
              Center(

                child: Form(
                  key:_formKey,
                  child: Container(
                    padding:EdgeInsets.symmetric(vertical:16.0,horizontal:16.0),
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:[
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(labelText: 'Course',labelStyle: TextStyle(fontFamily: 'Courgette')),
                            icon: Icon(Icons.arrow_drop_down),
                            onChanged: (val){
                              course = val;
                            },
                            validator: (value) => value == null ? 'field required' : null,
                            value: course, // guard it with null if empty
                            items: _courses.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: new Text(item),
                              );
                            }).toList(),
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(labelText: 'Semester',labelStyle: TextStyle(fontFamily: 'Courgette')),

                            icon: Icon(Icons.arrow_drop_down),
                            onChanged: (val){
                              _onSelectedSem(val,course);
                              sem = val;
                            },
                            validator: (value) => value == null ? 'field required' : null,
                            value: sem, // guard it with null if empty
                            items: _semesters.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: new Text(item),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 5,),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(labelText: 'Subject Name',labelStyle: TextStyle(fontFamily: 'Courgette')),
                            icon: Icon(Icons.arrow_drop_down),
                            onChanged: (val){
                              _onSelectedSub(val);
                              subject = val;
                            },
                            validator: (value) => value == null ? 'field required' : null,
                            value: subject, // guard it with null if empty
                            items: _subjects.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: new Text(item),

                              );
                            }).toList(),
                          ),
                          SizedBox(height: 5,),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(labelText: 'Module',labelStyle: TextStyle(fontFamily: 'Courgette')),

                            icon: Icon(Icons.arrow_drop_down),
                            onChanged: (val){
                              module = val;
                            },
                            validator: (value) => value == null ? 'field required' : null,
                            value: module, // guard it with null if empty
                            items: _modules.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: new Text(item),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 5,),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Topic Name',labelStyle: TextStyle(fontFamily: 'Courgette')),
                            validator: (value){
                              return  value.isEmpty? 'please enter Topic name': null;
                            },
                            onChanged:(val){
                              setState(() {
                                topic = val;
                              });
                            },
                           ),
                          Spacer(),
                          Container(
                              padding:EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
                              child:RaisedButton(
                                color: Colors.lightBlue,
                                child:Text("Upload Note"),

                                onPressed: () async {

                                  final form=_formKey.currentState;
                                  if(form.validate()){


                                    uploadNotes();
                                    print("Yep");
                                    form.save();
                                    //_showDialogue(context);
                                  }
                                },
                              )
                          )
                        ]
                    ),
                  ),
                ),
              )
      ),
    );

  }
  getPdfAndUpload(String notesId)async{
    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      //generate
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    File fileUrl = await FilePicker.getFile(type: FileType.custom);
    String fileName = '${randomName}.pdf';
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(fileName);
    UploadTask uploadTask = storageReference.putFile(fileUrl);
    await(await uploadTask);
    print('File Uploaded');
    Navigator.of(context).pop();
    String filename;
    filename=await storageReference.getDownloadURL();
    print (filename);
    databaseService.addNote(filename, notesId);
  }

  _showDialogue(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(content:Text('Submitting Form')));
  }

  void _onSelectedSem(String value,String course) {
    setState(() {

      sem = value;
      if(course =='Computer Science & Engineering'|| course=='All') {
        _subjects = List.from(_subjects)
          ..addAll(repo.getLocalBySemesterscse(value));
      }
      else if(course =='Civil Engineering' || course=='All') {
        _subjects = List.from(_subjects)
          ..addAll(repo.getLocalBySemestersce(value));
      }

    });
  }

  void _onSelectedSub(String value) {
    setState(() => subject = value);
  }

}