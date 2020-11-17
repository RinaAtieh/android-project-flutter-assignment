import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:hello_me/profile_view.dart';
import 'package:hello_me/user_auth.dart';
import 'package:provider/provider.dart';


FirebaseAuth auth = FirebaseAuth.instance;
int succ=0;

class LoginPage extends StatefulWidget {
  final Set<WordPair> saved ;
  LoginPage({Key key, @required this.saved}) : super(key: key);

  @override
  loginScreen createState() => loginScreen();
}

class loginScreen extends State<LoginPage>{

  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _confirm;
  static final _formKey = new GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  //final form = _formKey.currentState;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _confirm = TextEditingController(text: "");
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Builder(
          builder: (context) =>
              Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Welcome to Startup Names Generator, please login below',
                          )),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          obscureText: true,
                          controller: _password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Container(
                        //height: 50,
                        //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.red,
                            child: Text('Log in'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16.0))),
                            onPressed: () async{
                              if (!await user.signIn(
                                _email.text, _password.text))
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                    content: new Text('There was an error logging into the app')));


                              else {
                                //form.save();
                                //Navigator.popUntil(context, ModalRoute.withName('/'));
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        profile_page(saved: widget.saved, email: this._email.text.toString())));
                              }
                            },
                          )
                      ),


                      Container(
                        //height: 50,
                        //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            child: Text('New user? Click to sign up'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16.0))),
                            onPressed: () async{
                              // UserCredential userCredential = await FirebaseAuth.
                              // instance.createUserWithEmailAndPassword
                              // (email: this._email.text, password:  this._password.text);
                              // showBottomSheet(
                              //     context: context,
                              //     builder: (context) => Container(
                              //       color: Colors.red,
                              //     ));
                              _confirm.text = _password.text;
                              confirm_password();
                            },
                          )
                      ),




                    ]
                ),
              )
      ),
    );
  }
  Widget confirm_password(){
    final user = Provider.of<UserRepository>(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
          height: 200,
            child: Column (
                children: <Widget>[
                  const Text(''),
              const Text('please confirm your password below:'),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      obscureText: true,
                      controller: _confirm,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: valpass(_password.text,_confirm.text),
                      ),
                      cursorColor: Colors.red, //?
                    ),
                  ),

              ElevatedButton(
                child: const Text('Confirm'),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green)),
                onPressed: () async{
                  if(_password.text == _confirm.text){
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text, password: _password.text);
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                        profile_page(saved: widget.saved, email: this._email.text.toString())));
                  }
                  else {
                    //print("here");
                    return const Text('Passwords must match');
                    //   validator: (value){
                    //     if(value.isEmpty){
                    //       return 'Passwords must match';
                    //     }
                    //     return null;
                    //   },
                    // );
                  }
            }

                    //() => Navigator.pop(context),
              )
              ]

            ),

          );
        }
    );
  }
  String valpass(String val1, String val2){
    if(val1!=val2)
      return "Passwords must match";
    else return null;
  }
}
