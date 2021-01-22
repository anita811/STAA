import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Quiz/play_quiz.dart';
import 'package:quizapp/SignUp_SignIn/Login/login_screen.dart';
import 'package:quizapp/services/database.dart';
import '../drawerScreen.dart';
import 'create_quiz.dart';

class MyHomePage extends StatefulWidget {
  final String userType,userName,userEmail;
  MyHomePage(this.userType, this.userName, this.userEmail);

  @override
  _MyHomePageState createState() => _MyHomePageState(this.userType, this.userName, this.userEmail);
}

class _MyHomePageState extends State<MyHomePage> {
  final String userType,userName,userEmail;

  _MyHomePageState(this.userType, this.userName, this.userEmail);

  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  Widget quizList() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 5,),
          StreamBuilder(
            stream: quizStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container()
                  : ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                      quizTitle: snapshot.data.docs[index].data()['quizTitle'],
                      quizDesc: snapshot.data.docs[index].data()['quizDesc'],
                      department: snapshot.data.docs[index].data()['department'],
                      difficulty: snapshot.data.docs[index].data()['difficulty'],
                      quizId: snapshot.data.docs[index].data()['quizId'],
                      noOfQuestions: snapshot.data.docs.length,
                      userType:userType,
                    );
                  });
            },
          )
        ],
      ),
    );
  }
  @override
   void initState() {

     databaseService.getQuizData().then((val) {
       setState(() {
         quizStream = val;
       });
     });
     super.initState();
   }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomPadding:false,
      backgroundColor: Colors.white,
      drawer:SideDrawer(userType,userName,userEmail),
      appBar: AppBar(
        title: Text('Quiz'),
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
                Timer(Duration(seconds: 1), () {
                  // 1s over, navigate to a new page
                  Navigator.of(context).popUntil((route) => false);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),);
                });

                //Navigator.pop(context);
              },

            );
          })
        ],
      ),

      body:SingleChildScrollView(

          child:quizList(),
      ),
      floatingActionButton: getFAB(),

    );
  }
  Widget getFAB(){
    if(userType!="Student"){
      return  FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
             Navigator.push(
           context, MaterialPageRoute(builder: (context) => CreateQuiz()));
    },
    );
    }
  }
}

// ignore: must_be_immutable
class QuizTile extends StatelessWidget {
  final String quizTitle, quizDesc, department, difficulty, quizId;
  String userType;
  final int noOfQuestions;
  DatabaseService databaseService = new DatabaseService();
  QuizTile(
      { @required this.quizTitle,
        @required this.quizDesc,
        @required this.department,
        @required this.difficulty,
        @required this.quizId,
        @required this.noOfQuestions,
        @required this.userType,
      }
      );
   deleteQuiz(){
     Map<String, String> quizData = {
       "quizTitle" : quizTitle,
       "quizDesc" : quizDesc,
       "department":department,
       "difficulty":difficulty,
       "quizId":quizId
     };

     databaseService.delQuizData(quizData, quizId);
   }
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      textColor: Colors.red[300],
      child: Text("Delete",),
      onPressed:  () {
        deleteQuiz();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure ?"),
      content: Text("Are you sure to delete the quiz"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => QuizPlay(quizId)
        ));
      },

      onLongPress: (){
        if(userType!='Student') {
          showAlertDialog(context);
        }
      },
      child: Container(
        margin:EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 145,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                color: Colors.blue[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        quizTitle,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        quizDesc,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
