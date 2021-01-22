import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizapp/SignUp_SignIn/Login/login_screen.dart';
import 'package:quizapp/services/database.dart';
import '../../constants.dart';
import 'background.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => new _SignupScreenState();
}

class _SignupScreenState  extends State<SignupScreen> {

  String selectedType;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    List<String> _userType = <String>[
      'Student',
      'Faculty',
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
        body: Background(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "SIGNUP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.03),
                TextFieldContainer(
                 child: TextFormField(
                   onSaved: (val){},
                   controller: _nameController,
                   cursorColor: kPrimaryColor,
                   decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: "Name",
                    border: InputBorder.none,
                  ),
                ),
                ),
                  TextFieldContainer(
                    child: TextFormField(
                      onSaved: (val){},
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: kPrimaryColor,
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(29)
                ),
                child: DropdownButton<String>(
                  value: selectedType,
                  iconSize: 30,
                  elevation: 50,
                  onChanged: (selectedUserType) {
                    print('$selectedUserType');
                    setState(() {
                      selectedType = selectedUserType;
                    });
                  },
                  items: _userType
                      .map((value) => DropdownMenuItem(
                    child: Text(value,),
                    value: value,
                  ))
                      .toList(),
                  isExpanded: false,
                  hint: Text(
                    'Choose User Type                             ',
                  ),
                ),
              ),
                TextFieldContainer(
                 child: TextFormField(

                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (val){},
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: Icon(
                      Icons.visibility,
                      color: kPrimaryColor,
                    ),
                    hintText: "Password",
                    border: InputBorder.none,
                  ),
                ),
              ),
                  TextFieldContainer(
                    child: TextFormField(
                      obscureText: true,
                      controller: _repasswordController,
                      onSaved: (val){},
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: kPrimaryColor,
                        ),
                        suffixIcon: Icon(
                          Icons.visibility,
                          color: kPrimaryColor,
                        ),
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FlatButton(
                      color: kPrimaryColor,
                      minWidth: size.width * 0.8,
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      child: Text(
                        "Sign up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        await Firebase.initializeApp();
                        if (_nameController.text != null ||_repasswordController.text != null ) {
                          if (_passwordController.text ==
                              _repasswordController.text) {
                            if ((selectedType == 'Faculty' && _emailController
                                .text.endsWith('scmsgroup.org') == true )||(selectedType == 'Student' && _emailController
                                .text.endsWith('scmsgroup.org') == false)) {
                              try {
                                User user = (await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,)).user;

                                await DatabaseService(uid: user.uid)
                                    .updateUserData(
                                    _nameController.text, _emailController.text,
                                    selectedType);

                                if (user != null) {
                                  User updateUser = FirebaseAuth.instance
                                      .currentUser;
                                  updateUser.updateProfile(
                                      displayName: _nameController.text);
                                  showInSnackBar(_emailController.text);
                                  Timer(Duration(seconds: 5), () {
                                    // 1s over, navigate to a new page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return LoginScreen();
                                        },
                                      ),
                                    );
                                  });


                                }
                              }
                              catch (e) {
                                print(e);
                                _nameController.text = "";
                                _passwordController.text = "";
                                _repasswordController.text = "";
                                _emailController.text = "";
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
                            }
                            else {
                              _nameController.text = "";
                              _passwordController.text = "";
                              _repasswordController.text = "";
                              _emailController.text = "";
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Alert"),
                                      content: Text(
                                          "Try again"),
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
                          }
                          else {
                            _nameController.text = "";
                            _passwordController.text = "";
                            _repasswordController.text = "";
                            _emailController.text = "";
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Alert"),
                                    content: Text(
                                        "Please make sure your passwords match"),
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
                        }
                        else {
                          _nameController.text = "";
                          _passwordController.text = "";
                          _repasswordController.text = "";
                          _emailController.text = "";
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Alert"),
                                  content: Text("All fields are mandatory"),
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
                    login: false,
                    press: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
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
    );
  }
  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value +'Registered Successfully')
    ));
  }


}


class DropdownList extends StatefulWidget {
  DropdownList({Key key}) : super(key: key);

  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String selectedType = 'Student';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> _userType = <String>[
      'Student',
      'Faculty',
    ];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(29)
      ),
      child: DropdownButton<String>(
        value: selectedType,
        iconSize: 30,
        elevation: 50,
        onChanged: (selectedUserType) {
          print('$selectedUserType');
          setState(() {
            selectedType = selectedUserType;
          });
        },
        items: _userType
            .map((value) => DropdownMenuItem(
          child: Text(value,),
          value: value,
        ))
            .toList(),
        isExpanded: false,
        hint: Text(
          'Choose User Type                             ',
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


