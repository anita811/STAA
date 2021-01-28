import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class QuestionModel {
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String correctOption;
  bool answered;
}
class Note
{
  String subject;
  String semester;
  String module;
  String chapter;
  save(){
    print("Note Saved");
  }
}

class DatabaseService {
  final String uid;
  String userType;
  String userName;
  String file;
  DatabaseService({ this.uid });

  Future<void> updateUserData(String name, String email, String userType) async {

    return await FirebaseFirestore.instance.collection('user').doc(uid).set({
      'name': name,
      'email':email,
      'userType': userType,
    });
  }

   getuserType() async{
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .get().then((doc) {
      userType = doc.data()['userType'];

    });
    return userType;
  }

  getuserName() async{
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .get().then((doc) {
      userName = doc.data()['name'];

    });
    return userName;
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> delQuizData(Map quizData, String quizId) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .delete();
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() async {
    await Firebase.initializeApp();
    return  FirebaseFirestore.instance.collection("quiz").snapshots();
  }

  getQuestionData(String quizId) async{
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  Future<void> addNotesData(Map notesData, String notesId) async {
  await Firebase.initializeApp();
  print("Note Saved");
  await FirebaseFirestore.instance
      .collection("notes")
      .doc(notesId)
      .set(notesData)
      .catchError((e) {
  print(e);
  print("Error in note saving");
  });
  }

  Future<void> delNotesData( String notesId) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("quiz")
        .doc(notesId)
        .delete();
  }

  Future<void> addNote(String file, String notesId) async {
    await Firebase.initializeApp();
    print("pdf Saved");
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(notesId)
        .update(
        { "file": file}
    )
        .catchError((e) {
      print(e);
      print("Error in saving pdf");
    });
  }

  getNotesData() async{
  await Firebase.initializeApp();
  print("Getting Note Details");
  return await FirebaseFirestore.instance
      .collection("notes")
      .snapshots();
  }

  getFile(String notesId) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(notesId)
        .get().then((doc) {
      file = doc.data()['file'];
    });
    print(file);
    return file;
  }

}
