import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'add_question.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();

  String quizTitle, quizDesc,department,difficulty;

  bool isLoading = false;
  String quizId;

  createQuiz(){

    quizId = randomAlphaNumeric(16);
    if(_formKey.currentState.validate()){

      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizTitle" : quizTitle,
        "quizDesc" : quizDesc,
        "department":department,
        "difficulty":difficulty,
        "quizId":quizId
      };

      databaseService.addQuizData(quizData, quizId).then((value){
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>  AddQuestion(quizId)
        ));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(

        appBar: AppBar(
          leading: BackButton(
            color: Colors.black54,
          ),
          title: Text('Quiz'),
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
                },
              );
            })
          ],
          brightness: Brightness.light,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          //brightness: Brightness.li,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  validator: (val) => val.isEmpty ? "Enter Quiz Title" : null,
                  decoration: InputDecoration(
                      hintText: "Quiz Title"
                  ),
                  onChanged: (val){
                    quizTitle = val;
                  },
                ),
                SizedBox(height: 5,),
                TextFormField(
                  validator: (val) => val.isEmpty ? "Enter Quiz Description" : null,
                  decoration: InputDecoration(
                      hintText: "Quiz Description"
                  ),
                  onChanged: (val){
                    quizDesc = val;
                  },
                ),
                SizedBox(height: 5,),
                TextFormField(
                  validator: (val) => val.isEmpty ? "Enter department" : null,
                  decoration: InputDecoration(
                      hintText: "Department"
                  ),
                  onChanged: (val){
                    department= val;
                  },
                ),
                SizedBox(height: 5,),TextFormField(
                  validator: (val) => val.isEmpty ? "Enter difficulty level" : null,
                  decoration: InputDecoration(
                      hintText: "Beginner/Intermediate/Difficult"
                  ),
                  onChanged: (val){
                    difficulty = val;
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    createQuiz();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Create Quiz",
                      style: TextStyle(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
              ],)
            ,),
        ),
      );
    }
  }
