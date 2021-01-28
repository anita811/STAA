import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/SignUp_SignIn/Login/login_screen.dart';
import 'package:quizapp/services/database.dart';
import '../drawerScreen.dart';
import 'NoteForm.dart';
import 'NoteListItem.dart';

class notesHomePage extends StatefulWidget {
  final String userType,userName,userEmail;
 notesHomePage(this.userType, this.userName, this.userEmail);

  @override
  _notesHomePageState createState() => _notesHomePageState (this.userType, this.userName, this.userEmail);
}

class _notesHomePageState extends State<notesHomePage>
{
  final String userType,userName,userEmail;
  _notesHomePageState(this.userType, this.userName, this.userEmail);
  Stream notesStream;
  DatabaseService databaseService = new DatabaseService();

  Widget notesList() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 5,),
          StreamBuilder(
            stream: notesStream,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Container()
                  : ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return NoteListItem(
                    snapshot.data.docs[index].data () ['course'],
                    snapshot.data.docs[index].data()['subject'],
                    snapshot.data.docs[index].data()['sem'],
                    snapshot.data.docs[index].data()['module'],
                    snapshot.data.docs[index].data()['topic'],
                    snapshot.data.docs[index].data()['notesId'],
                    userType
                    ,
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
     databaseService.getNotesData().then((val) {
       setState(() {
         notesStream = val;
       });
     });
     super.initState();
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:SideDrawer(userType,userName,userEmail),
      resizeToAvoidBottomPadding:false,
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

      body:SingleChildScrollView(

          child:notesList(),
      ),
      floatingActionButton: getFAB(),

    );
  }
  Widget getFAB(){
    //if(userType!="Student"){
      return  FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
             Navigator.push(
           context, MaterialPageRoute(builder: (context) => NoteForm()));
    },
    );
    }
  //}

}

