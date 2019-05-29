import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlaylistCreation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController();
    var formField = FractionallySizedBox(
      child: TextFormField(
        cursorColor: RobeatsThemeData.PRIMARY,
        controller: textEditingController,
        decoration: InputDecoration(hintText: 'Playlist name', icon: Icon(Icons.input)),
        validator: (String input) {
          if (input.length < 3 || input == null)
            return "Input a name that's at least 3 characters in length!";
          else
            return null;
        },
      ),
      widthFactor: 0.85,
    );

    Function callback = (GlobalKey<FormState> key) {
      if (key.currentState.validate()) {
        String value = textEditingController.value.text;
        Playlist playlist = Playlist.create(value);

        popRoute(context);
      }
    };

    Form form = _createForm([Center(child: formField)], callback, context);
    Icon icon = Icon(
      Icons.library_music,
      size: 45.0,
    );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(child: icon, padding: EdgeInsets.only(bottom: 40.0)),
          form,
        ],
      ),
    );
  }

  Form _createForm(List<Widget> fields, Function onPressed, BuildContext context) {
    List<Widget> children = List<Widget>.from(fields);
    var key = GlobalKey<FormState>();

    RaisedButton exitButton = RaisedButton(
      color: RobeatsThemeData.PRIMARY,
      textColor: Colors.white,
      onPressed: () => popRoute(context),
      child: Text("Exit"),
    );

    RaisedButton createButton = RaisedButton(
      color: RobeatsThemeData.PRIMARY,
      textColor: Colors.white,
      onPressed: () => onPressed(key),
      child: Text("Create"),
    );

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(child: exitButton, padding: EdgeInsets.only(top: 20.0)),
        Padding(child: createButton, padding: EdgeInsets.only(top: 20, left: 15.0))
      ],
    ));

    return Form(
      key: key,
      child: Column(children: children),
    );
  }

  void pushRoute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (buildContext) => this),
    );
  }

  void popRoute(BuildContext context) {
    Navigator.pop(context);
  }
}
