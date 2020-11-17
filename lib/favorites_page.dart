import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class sug_screen extends StatefulWidget{
  final Set<WordPair> favorites ;

  sug_screen({Key key, @required this.favorites}) : super(key: key);
  @override
  suggestionScreen createState() => suggestionScreen();
}

class suggestionScreen extends State<sug_screen> {
  Widget _buildRow(WordPair pair){
    return ListTile(
        title: Text(pair.asPascalCase),
        trailing: Icon(Icons.delete_outline, color: Colors.red),
        onTap: () {
          setState((){ widget.favorites.remove(pair);}

          );
          //Scaffold.of(context).showSnackBar(new SnackBar(
          //   content: new Text('Deletion is not implemented yet')));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
          backgroundColor: Colors.red,
        ),
        body: new ListView.separated(
          itemCount: widget.favorites.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1.0, color: Colors.grey),
          itemBuilder: (context, index) {
            return _buildRow(widget.favorites.toList()[index]);
          },
        ));
  }

}