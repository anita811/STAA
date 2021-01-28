import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Notes/StudentNoteListItem.dart';
import 'package:quizapp/Notes/student_notes.dart';
import 'package:quizapp/SignUp_SignIn/Login/login_screen.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/services/repository.dart';

import '../drawerScreen.dart';

class  StudentNote extends StatefulWidget
{
  final String userType,userName,userEmail;
  StudentNote(this.userType, this.userName, this.userEmail);
  @override
  _StudentNoteState createState() => _StudentNoteState(this.userType, this.userName, this.userEmail);
}

class _StudentNoteState extends State<StudentNote> {
  final String userType,userName,userEmail;
  _StudentNoteState(this.userType, this.userName, this.userEmail);

  final _formKey=GlobalKey<FormState>();

  static const List<String> modules =['1', '2', '3', '4', '5','6'];


  DatabaseService databaseService = new DatabaseService();
  Stream notesStream;
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

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Scaffold(
          drawer:SideDrawer(userType,userName,userEmail),
          appBar: AppBar(
            title: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 22

                ),
                children: <TextSpan>[
                  TextSpan(text: 'Notes', style: TextStyle(fontWeight: FontWeight.w600
                      , color: Colors.white))
                ],
              ),
            ),
            brightness: Brightness.light,
            elevation: 0.0,
            backgroundColor: Colors.blue,
            //brightness: Brightness.li,
            actions: <Widget>[
              Builder(builder: (BuildContext context) {
//5
                return FlatButton(
                  child: const Text('Sign out'),
                  textColor: Theme
                      .of(context)
                      .buttonColor,
                  onPressed: () async {
                    final User user = await FirebaseAuth.instance.currentUser;
                    if (user == null) {
//6
                      Scaffold.of(context).showSnackBar(const SnackBar(
                        content: Text('No one has signed in.'),
                      ));
                      return;
                    }
                    await FirebaseAuth.instance.signOut();
                    final String useremail = user.email;
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(useremail + ' has successfully signed out.'),

                    ));
                    Navigator.popUntil(context, (route) => false);
                     Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
                  },

                );
              })
            ],
          ),
          body:Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color:Colors.blue,width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child:Builder(
                builder:(context)=>Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Search ",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize:20.0),),
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



                        Container(
                            padding:EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
                            child:RaisedButton(
                              color: Colors.lightBlue,
                              child:Text("Search Note"),
                              onPressed: (){
                                final form=_formKey.currentState;
                                if(form.validate()){
                                  print("Yep");
                                  form.save();
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (context)=> new StudentSearch(course,subject,sem,module,topic)));
                                }
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                )
            ),

          ),
        )
    );
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
