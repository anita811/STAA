import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';

import 'ViewPdf.dart';
class NoteListItem extends StatelessWidget
{
  final String _course;
  final String _subject;
  final String _semester;
  final String _module;
  final String _topic;
  final String notesId;
  final String userType;

  NoteListItem(this._course, this._subject, this._semester,
      this._module, this._topic,this.notesId, this.userType,);
  DatabaseService databaseService = new DatabaseService();

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
        databaseService.delNotesData(notesId);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("DELETE"),
      content: Text("Are you sure to delete the $_subject- module $_module- $_topic"),
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

    DatabaseService databaseService = new DatabaseService();

    return GestureDetector(
      onTap: ()async{
        String url=await databaseService.getFile(notesId);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)=>ViewPdf(url,_topic),

            )
        );
        print(notesId);
      },
      onLongPress: (){

          showAlertDialog(context);

      },
      child:  Container(
        margin:EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 6),
        color: Colors.grey[200],
        child: Column(
        children: [
          SizedBox(height: 25,),
          Row(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.book_outlined,size: 50,color: Colors.grey,),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_course - Semester $_semester',
                        style: TextStyle(color:Colors.black ,
                            fontSize: 14.0,fontWeight:FontWeight.w500),
                      ),
                      SizedBox(height: 4,),
                      Text(_subject,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4,),
                      Text('Module $_module - $_topic',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25,),
        ],
      ),
    ),
    );
  }
}