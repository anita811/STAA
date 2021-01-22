import 'package:flutter/material.dart';
import 'package:quizapp/Notes/studentnote.dart';
import 'package:quizapp/home.dart';
import 'Notes/Notes.dart';
import 'Quiz/home.dart';

class SideDrawer extends StatelessWidget {
  final userType,userName,userEmail;
   SideDrawer(this.userType, this.userName, this.userEmail) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(

                accountName: Text(userName),
                accountEmail: Text(userEmail),
                currentAccountPicture: CircleAvatar(

                ),
              ),
              ListTile(
                title: Text('Home'),
                leading: Icon(Icons.home),
                onTap: () => Navigator.pushReplacement(context,   MaterialPageRoute(
                  builder: (context) {
                    return Home(userType,userName,userEmail);
                  },
                ),)
              ),
              ListTile(
                title: Text('Notes'),
                leading: Icon(Icons.menu_book),
                onTap: () => Navigator.push(context,   MaterialPageRoute(
                  builder: (context) {
                    if(userType!='Student') {
                      return notesHomePage(userType, userName, userEmail);
                    }
                    else {
                        return StudentNote(userType, userName, userEmail);
                      }
                  },
                ),)
              ),
              ListTile(
                title: Text('Quiz'),
                leading: Icon(Icons.lightbulb),
                onTap: () => Navigator.push(context,   MaterialPageRoute(
                  builder: (context) {
                    return MyHomePage(userType,userName,userEmail);
                  },
                ),)
              )
            ],
          ),
        ),
      ),
    );
  }
}