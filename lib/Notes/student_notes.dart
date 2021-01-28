import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';

import 'StudentNoteListItem.dart';

class StudentSearch extends StatefulWidget
{

  // ignore: non_constant_identifier_names
  final String _course_searched;
  // ignore: non_constant_identifier_names
  final String _subject_searched;
  // ignore: non_constant_identifier_names
  final String _semester_searched;
  // ignore: non_constant_identifier_names
  final String _module_searched;
  // ignore: non_constant_identifier_names
  final String _topic_searched;


  StudentSearch(this._course_searched,
      this._subject_searched,this._semester_searched,
      this._module_searched,this._topic_searched);

  @override
  _StudentSearchState createState() => _StudentSearchState(this._course_searched,
      this._subject_searched,this._semester_searched,
      this._module_searched,this._topic_searched);
}

class _StudentSearchState extends State<StudentSearch> {

  // ignore: non_constant_identifier_names
  final String _course_searched;
  final String _subject_searched;
  final String _semester_searched;
  final String _module_searched;
  final String _topic_searched;


  _StudentSearchState(this._course_searched,
      this._subject_searched,this._semester_searched,
      this._module_searched,this._topic_searched);
  Stream notesStream;
  DatabaseService databaseService = new DatabaseService();


  void initState() {
    databaseService.getNotesData().then((val) {
      setState(() {
        notesStream = val;
      });
    });
    super.initState();
  }
  @override
  Widget notesList() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10,),
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
                    String course=snapshot.data.docs[index].data () ['course'];
                    String subject=snapshot.data.docs[index].data()['subject'];
                    String sem =snapshot.data.docs[index].data()['sem'];
                    String module =snapshot.data.docs[index].data()['module'];
                    String topic =snapshot.data.docs[index].data()['topic'];
                    String file=snapshot.data.docs[index].data()['file'];
                    if( _subject_searched==subject&& _module_searched==module){
                      return StudentNoteListItem(
                        snapshot.data.docs[index].data() ['course'],
                        snapshot.data.docs[index].data()['subject'],
                        snapshot.data.docs[index].data()['sem'],
                        snapshot.data.docs[index].data()['module'],
                        snapshot.data.docs[index].data()['topic'],
                        snapshot.data.docs[index].data()['file'],

                      );

                    }
                  },);
            },
          ),
          SizedBox(height: 50,),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Available Notes"),
        centerTitle: true,
        elevation: 0.8,

      ),

      body:SingleChildScrollView(

            child:notesList(),
          ),


    );

  }
}