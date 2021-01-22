import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Notes/StudentNoteListItem.dart';
import 'package:quizapp/Notes/studentsearch.dart';
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
  String subject,teacher;

  static const  List<String> teachers = [
    'Anuradha Sreeram',
    'K.S Chithra',
    'K.J Yesudas',
    'SP Balasubramanyam',
  ];


  static const List<String> modules =['1', '2', '3', '4', '5','6'];


  DatabaseService databaseService = new DatabaseService();
  Stream notesStream;
  String course;
  String sem;
  String module=_modules[0];
  String topic;

  bool isLoading = false;
  String notesId;

  List<String> _subjects=[];
  List<String> _semesters=[];
  static const List<String> _modules =['1', '2', '3', '4', '5','6'];

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
                    /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );*/
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
                          decoration: InputDecoration(labelText: 'Teacher Name',labelStyle: TextStyle(fontFamily: 'Courgette')),
                          icon: Icon(Icons.arrow_downward),
                          value: teacher, // guard it with null if empty
                          items: teachers.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: new Text(item),
                            );
                          }).toList(),
                          onChanged: (String newValue) => setState(() { teacher=newValue;}),
                        ),

                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Semester',labelStyle: TextStyle(fontFamily: 'Courgette')),

                          icon: Icon(Icons.arrow_drop_down),
                          onChanged: (val){
                            _onSelectedSem(val);
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

                          icon: Icon(Icons.arrow_downward),
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

                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Module Number',labelStyle: TextStyle(fontFamily: 'Courgette')),
                          icon: Icon(Icons.arrow_downward),
                          value: module, // guard it with null if empty
                          items: modules.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: new Text(item),
                            );
                          }).toList(),
                          onChanged: (String newValue) => setState(() { module=newValue;}),
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
                                      builder: (context)=> new StudentSearch()));
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

  void _onSelectedSem(String value) {
    setState(() {

      sem = value;
      _subjects = List.from(_subjects)..addAll(repo.getLocalBySemesterscse(value));
    });
  }

  void _onSelectedSub(String value) {
    setState(() => subject = value);
  }

}
