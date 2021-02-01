import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizapp/SignUp_SignIn/Signup/signup_screen.dart';
import 'package:quizapp/home.dart';
import 'package:quizapp/services/database.dart';
import 'file:///C:/Users/User/AndroidStudioProjects/quizapp/lib/widgets/custom_alert_dialog.dart';

import '../../constants.dart';
import 'background.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String userType,userName,email;

   @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    void showAlertDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController _emailControllerField =
            TextEditingController();
            return CustomAlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 4.5,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Text("Insert Reset Email:"),
                    TextField(
                      controller: _emailControllerField,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: "something@example.com",
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(25.0),
                        color: kPrimaryColor,
                        child: MaterialButton(
                          minWidth: size.width / 2,
                          padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                          child: Text(
                            "Send Reset Email",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            try {
                              FirebaseAuth.instance.sendPasswordResetEmail(
                                  email: _emailControllerField.text);
                              Navigator.of(context).pop();
                            } catch (e) {
                              print(e);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(' Invalid Email Address!!'),
                              ));
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
        body:Background(
           child: Center(
             child: SingleChildScrollView(
                 child: Form(
                   key: formKey,
                   child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                           Text(
                                "LOGIN",
                           style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     SizedBox(height: size.height * 0.03),
                     SizedBox(height: size.height * 0.03),
                        TextFieldContainer(
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: kPrimaryColor,
                            onSaved: (val) {},
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.mail,
                                color: kPrimaryColor,
                              ),
                              hintText: "Email ID",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      TextFieldContainer(
                        child:TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          onSaved: (val){},
                          cursorColor: kPrimaryColor,
                          validator: (val) => val.length < 6 ? 'Password too short.' : null,
                          decoration: InputDecoration(
                            hintText: "Password",
                            icon: Icon(
                              Icons.lock,
                              color: kPrimaryColor,
                            ),
                            suffixIcon: Icon(
                              Icons.visibility,
                              color: kPrimaryColor,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                       ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                                child: Text(
                                  "Forgot Password",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(color: Colors.black),
                                ),
                                onPressed: () {
                                  showAlertDialog(context);
                                }),
                          ],
                        ),

                    ClipRRect(
                       borderRadius: BorderRadius.circular(29),
                       child: FlatButton(
                         color: kPrimaryColor,
                         minWidth: size.width / 1.2,
                         padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                         child: Text(
                           "Sign in",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                             fontSize: 18.0,
                             color: Colors.white,
                            ),
                         ),
                         onPressed: () async {
                           await Firebase.initializeApp();
                           try {
                             User user =
                                 (await FirebaseAuth.instance.signInWithEmailAndPassword(
                                   email: _emailController.text,
                                   password: _passwordController.text,
                                 )).user;
                             userType=await DatabaseService(uid: user.uid).getuserType();
                             userName=await DatabaseService(uid: user.uid).getuserName();
                             if (user != null) {

                               email=_emailController.text;
                               _emailController.text = "";
                               _passwordController.text = "";

                               Navigator.of(context).popUntil((route) => false);
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) {
                                     return Home(userType, userName,email);

                                   },
                                 ),
                               );
                               //_emailController.text = "";
                               //_passwordController.text = "";
                             }
                           } catch (e) {
                             print(e);
                             _emailController.text = "";
                             _passwordController.text = "";
                             showDialog(
                                 context: context,
                                 builder: (BuildContext context) {
                                   return AlertDialog(
                                     title: Text("Error"),
                                     content: Text(e.toString()),
                                     actions: [
                                       FlatButton(
                                         child: Text("Ok"),
                                         onPressed: () {
                                           Navigator.of(context).pop();
                                         },
                                       )
                                     ],
                                   );
                                 });
                           }
                         },
                       ),
                     ),
                        SizedBox(height: size.height * 0.03),
                        AlreadyHaveAnAccountCheck(
                          press: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignupScreen();
                                },
                              ),
                            );
                          },
                        ),

        ],
                 ),
             ),
           ),
        ),
    ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}


