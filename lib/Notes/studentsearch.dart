import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';

import 'StudentNoteListItem.dart';

class StudentSearch extends StatefulWidget
{

  @override
  _StudentSearchState createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {
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
                    return StudentNoteListItem(
                      snapshot.data.docs[index].data () ['course'],
                      snapshot.data.docs[index].data()['subject'],
                      snapshot.data.docs[index].data()['sem'],
                      snapshot.data.docs[index].data()['module'],
                      snapshot.data.docs[index].data()['topic'],
                      snapshot.data.docs[index].data()['notesId'],
                    );
                  });
            },
          )
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