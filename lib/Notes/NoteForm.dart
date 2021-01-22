import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/services/repository.dart';
import 'package:random_string/random_string.dart';

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
  File sample;
  File _image;
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
        "notesId":notesId
      };
      //addNotesData(Map notesData, String notesId)
      databaseService.addNotesData(notesData, notesId).then((value) {
        setState(() {
          isLoading = false;
          _showDialogue(context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      // ignore: deprecated_member_use
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image as File ;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async{
     // String fileName = basename(_image.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("image" + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(_image);
      uploadTask.then((res) {
        res.ref.getDownloadURL();
      });
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

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
                                  return  value.isEmpty? 'please enter chapter name': null;
                                },
                                onChanged:(val){
                                  setState(() {
                                    topic = val;
                                  });
                                },
                              ),
                              /*FormBuilderFilePicker(
                                attribute: "Document",
                                decoration: InputDecoration(labelText: "Select File"),
                                maxFiles: 1,
                                multiple: false,
                                previewImages: true,
                                onChanged: (val) => print(val),
                                fileExtension: "PDF",
                                fileType: FileType.custom,
                                selector: Row(
                                  children: <Widget>[
                                    Icon(Icons.file_upload),
                                    Text('Upload',),
                                  ],
                                ),
                                onFileLoading: (val) {
                                  getPdfAndUpload();
                                  print(val);
                                },
                              ),*/
                              FloatingActionButton(
                                onPressed:  getImage,
                                tooltip: 'Select file',
                                child: new Icon(Icons.sd_storage),
                              ),


                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  uploadNotes();
                                },
                                child:Container(
                                    padding:EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
                                    child:RaisedButton(
                                      color: Colors.lightBlue,
                                      child:Text("Upload Note"),
                                      onPressed: (){
                                        final form=_formKey.currentState;
                                        if(form.validate()){
                                          uploadPic(context);
                                          uploadNotes();
                                          print("Yep");
                                          form.save();
                                          Navigator.pop(context);
                                          //_showDialogue(context);
                                        }
                                      },
                                    )
                                ),
                              )
                            ]
                   ),
               ),
            ),
          )
        ),
    );

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