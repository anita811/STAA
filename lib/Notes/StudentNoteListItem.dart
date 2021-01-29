import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';
import 'ViewPdf.dart';
// ignore: must_be_immutable
class StudentNoteListItem extends StatelessWidget
{
  final String _course;
  final String _subject;
  final String _semester;
  final String _module;
  final String _topic;
  final String file;

  DatabaseService databaseService;

  StudentNoteListItem(this._course, this._subject, this._semester,
      this._module, this._topic, this.file);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ()async{
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)=>ViewPdf(file,_topic),

            )
        );
        print(file);
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
                        Text('$_course - sem $_semester',style: TextStyle(color:Colors.black ,fontSize: 14.0,fontWeight:FontWeight.w500),),
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