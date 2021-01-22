import 'package:flutter/material.dart';
class StudentNoteListItem extends StatelessWidget
{
  final String _course;
  final String _subject;
  final String _semester;
  final String _module;
  final String _topic;
  final String notesId;

  StudentNoteListItem(this._course, this._subject, this._semester,
      this._module, this._topic, this.notesId);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        margin:EdgeInsets.all(5.0),
        decoration:BoxDecoration(
          color:Colors.white,
          border:Border.all(color:Colors.lightBlueAccent,
              width: 1.0
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Course. $_course / Semester. $_semester',style: TextStyle(color:Colors.blue ,fontSize: 20.0,fontWeight:FontWeight.bold),),
            Text(_subject,style: TextStyle(fontSize: 18.0,fontFamily: 'Courgette',fontWeight:FontWeight.bold),),
            Text('Module. $_module / Chapter. $_topic ',style: TextStyle(fontSize: 16.0,fontFamily: 'Courgette',fontWeight:FontWeight.bold),),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                FlatButton.icon(onPressed: (){},label:Text('Download'),icon:Icon(Icons.arrow_circle_down),textColor: Colors.blue,),

              ],
            )
          ],
        )

    );
  }
}