import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/user_auth.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'favorites_page.dart';
import 'log_in_page.dart';

class profile_page_state extends State<profile_page> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);
  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('favorites');
  Map userDB = {};
  List userList = [];
  final fav = <WordPair>{};
  int flag = 0;

  //Set<WordPair> fav={};

  // #enddocregion RWS-var

  //_saved.union()

  Map data;

  addData() async {
    List<String> favAdd = new List(_saved.length);
    for (int i = 0; i < _saved.length; i++)
      favAdd[i] = _saved.toList()[i].asPascalCase;

    Map<String, dynamic> data = {
      "Saved": favAdd
    };

    var ID = widget.email;
    await collectionReference.doc(ID).set(data);
  }


  Future<void> fetchData() async {
    var ID = widget.email;
    Future<DocumentSnapshot> DS = collectionReference.doc(ID).get();
    DS.then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userDB = documentSnapshot.data();
        userList =
        userDB.containsKey("Saved") ? List.from(userDB['Saved']) : null;
      }
      else {
        print('document not exist');
      }
    });
  }

  Set<WordPair> updateSaved() {
    Set<WordPair> toSend = {};
    toSend.addAll(this._saved);
    if (flag == 0) {
      int len = (userList == null) ? -1 : userList.length;
      for (int j = 0; j < len; j++) {
        WordPair pair = WordPair(" ", userList[j].toString());
        if (!toSend.contains(pair.asPascalCase))
          toSend.add(pair);
      }

      len = (widget.saved == null) ? 0 : widget.saved.length;
      for (int i = 0; i < len; i++) {
        //print("contain"); print((toSend.any((element) => (element.compareTo(widget.saved.toList()[i].toString())==0))));
        //print((toSend.any((element) => (element.asPascalCase. == (widget.saved.toList()[i].asPascalCase)))));
        if (toSend.contains(widget.saved.toList()[i].asPascalCase) == false)
          toSend.add(widget.saved.toList()[i]);
      }
      flag = 1;
      _saved.clear();
      _saved.addAll(toSend);
    }
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => sug_screen(favorites: _saved)));
  }

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    userList.clear();
    fav.clear();
    fetchData();
    SnappingSheetController _controlSnap = SnappingSheetController();
    double _moveAmount = 0.0;
    String mailAdd = widget.email;
    return Scaffold(
        appBar: AppBar(
          title: Text('Startup Name Generator'),
          backgroundColor: Colors.red,
          actions: <Widget>[
            // Container(
            //   //height: 50,
            //   //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            //     child: RaisedButton(
            //       textColor: Colors.white,
            //       color: Colors.red,
            //       child: Text('exit_to_app'),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //       onPressed: () async {
            //         // if (log_in == 1)
            //         //   try {
            //         //     await FirebaseAuth.instance.signOut();
            //         //   } catch (e) {
            //         //     print(e); // TODO: show dialog with error
            //         //   }
            //         addData(); ////// here save final data to firebas
            //         Provider.of<UserRepository>(context).signOut();
            //         Navigator.popUntil(context, ModalRoute.withName('/'));
            //       },
            //     )
            // ),
            IconButton(
              icon: Icon(
                Icons.favorite,
              ),
              onPressed: () {
                // do something
                updateSaved();
                // Navigator.push(context, MaterialPageRoute(
                //     builder: (context) => sug_screen(favorites: fav)));
              },
            )
            , IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () {
                // do something
                addData(); ////// here save final data to firebas
                Provider.of<UserRepository>(context).signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
        ),
        // body: _buildSuggestions(),
        // bottomSheet:
        //       welcome_back(widget.email),
        body: Builder(
          builder: (context){
            return SnappingSheet(
              // snapPositions: const[
              //   SnapPosition(positionPixel:  0.0,
              //   snappingCurve: Curves.elasticOut,
              //   snappingDuration: Duration(milliseconds: 750)),
              //   SnapPosition(positionFactor: 0.4),
              //   SnapPosition(positionFactor: 0.8),
              // ],
              sheetBelow: SnappingSheetContent(
                child: Column (
                    children: <Widget>[
                      TextField(
                    decoration: InputDecoration(
                    labelText: ('   Welcome back, $mailAdd'),
                    focusColor: Colors.grey,
                      suffixIcon: InkWell(
                        child: Icon(Icons.keyboard_arrow_up),
                        onTap: (){
                          setState(() {
                            if(_controlSnap.currentSnapPosition.positionPixel==0.0){
                              _controlSnap.snapToPosition(SnapPosition(
                                positionPixel:  200,
                                snappingCurve:  Curves.elasticOut,
                              ));
                            }
                            else{
                              _controlSnap.snapToPosition(SnapPosition(
                                positionPixel: 0.0,
                                snappingCurve: Curves.elasticOut,
                              ));
                            }
                          });
                        },
                      )
                ),
                cursorColor: Colors.grey,
                ),
                const Text (''),
                Container(
                  margin: EdgeInsets.only(right: 300.0),
                  width: 100,
                    child:
                  CircleAvatar(
                      radius: 40,
                      //backgroundImage: AssetImage(''),
                    )
            ),
             TextField(
                decoration: InputDecoration(
                labelText: ('  $mailAdd'),
                ),
             ),
             ElevatedButton(
               child: const Text('Change avatar'),
               style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green)),
               onPressed: () async{
              })
                ])),
            sheetAbove: SnappingSheetContent(child: _buildSuggestions()),
            );
           })
          );
  }

// #enddocregion RWS-build
// #docregion RWS-var
  Widget sugg_snap_sheet(){
    return SnappingSheet(
      //onSnapEnd: () => welcome_back,
      //onMove: ,
      child: _buildSuggestions(),
      //initSnapPosition: SnapPosition(welcome_back(widget.email)),
      onSnapBegin: () => welcome_back(widget.email),
    );
  }

  Widget welcome_back(String email) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Column(
              children: <Widget>[
                const Text(''),
                const Text('Welcome back, email'),
              ],
            ),
          );
        });
  }
}
// #enddocregion RWS-var


class profile_page extends StatefulWidget {
  final Set<WordPair> saved ;
  String email;

  profile_page({Key key, @required this.saved, @required this.email}) : super(key: key);
  @override
  State<profile_page> createState() => profile_page_state();
}

// class welcome_user extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }
