import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SignUp_SignIn/Login/login_screen.dart';
import 'drawerScreen.dart';

class Home extends StatefulWidget {
  final String userType,userName,userEmail;
  const Home(this.userType,this.userName,this.userEmail) ;

  @override
  State<StatefulWidget> createState() {
    return _HomeState(this.userType,this.userName,this.userEmail);
  }
}
class _HomeState extends State<Home> {
  final String userType,userName,userEmail;
  _HomeState(this.userType,this.userName,this.userEmail);




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: SideDrawer(userType,userName,userEmail),
      appBar: AppBar(
        title: Text('STAA'),
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
              },
            );
          })
        ],
      ),
      body:  Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[ Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.computer),
                Text('Welcome to STAA   ')
              ],
            ),
          ),
            Spacer(),
           Text("'Notes under an Umbrella'",style: TextStyle(
               fontSize:20,
               color: Colors.black,
               fontWeight: FontWeight.w500),
           ),
            SizedBox(height: 6,),
           Text("   - an aid for both faculties and students",style: TextStyle(
               fontSize: 20,
               color: Colors.black,
               fontWeight: FontWeight.w500),),
            Spacer(),
           Image.asset(
            "assets/20748595.jpg",
             width: size.width * 1,
        ),
            Spacer(),
          ],
        ),
      ),

    );

  }

}


