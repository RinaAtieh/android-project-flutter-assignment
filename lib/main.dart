import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:hello_me/user_auth.dart';
import 'package:provider/provider.dart';

import 'favorites_page.dart';
import 'log_in_page.dart';


int log_in = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}


class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          //if (snapshot.data!=null)  log_in = 1;
          //else log_in = 0;

          return MyApp();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (_) => UserRepository.instance(),
        child: Consumer(
            builder: (context, UserRepository user, _){
              return MaterialApp(
                  title: 'Startup Name Generator',
                  home: RandomWords(),
                  color: Colors.red //?
              );
            }
        ));
  }
// #enddocregion build
}
// #enddocregion MyApp


// #docregion RWS-var
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

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
            //         Provider.of<UserRepository>(context).signOut();
            //       },
            //     )
            // ),
            IconButton(
              icon: Icon(
                Icons.favorite,
              ),
              onPressed: () {
                // do something
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => sug_screen(favorites: _saved)));
              },
            )
            , IconButton(
              icon: Icon(
                Icons.login,
              ),
              onPressed: () {
                // do something
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage(saved: this._saved)));
              },
            )
          ],
        ),
        body: _buildSuggestions(),
      );
  }
// #enddocregion RWS-build
// #docregion RWS-var
}
// #enddocregion RWS-var


class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}