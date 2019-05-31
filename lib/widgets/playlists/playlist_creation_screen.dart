import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/data/media_loader.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlaylistCreationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New playlist'),
      content: PlaylistCreation(),
    );
  }
}

class PlaylistCreation extends StatelessWidget {
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController();
    var formField = TextFormField(
      cursorColor: RobeatsThemeData.PRIMARY,
      controller: textEditingController,
      decoration: InputDecoration(hintText: 'Playlist name', icon: Icon(Icons.input)),
      validator: _invalidPlaylist,
    );

    Function callback = () {
      if (formKey.currentState.validate()) {
        String value = textEditingController.value.text;
        Playlist.create(value);

        Navigator.of(context).pop();
      }
    };

    Form form = _createForm([formField], callback, context);
    var icon = ConstrainedBox(
      constraints: BoxConstraints.loose(Size.square(60)),
      child: Icon(Icons.library_music, size: 60.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: icon, flex: 40),
        Expanded(child: form, flex: 60),
      ],
    );
  }

  String _invalidPlaylist(String identifier) {
    MediaLoader mediaLoader = MediaLibrary().mediaLoader;

    if (identifier.length < 3 || identifier == null) return "Minimum 3 characters!";

    if (mediaLoader
        .getMatchingPlaylists(identifier)
        .length > 0) return "Already exists!";

    return null;
  }

  Form _createForm(List<Widget> fields, Function onPressed, BuildContext context) {
    List<Widget> children = List<Widget>.from(fields);

    RaisedButton createButton = RaisedButton(
      color: RobeatsThemeData.PRIMARY,
      onPressed: onPressed,
      textColor: Colors.white,
      child: Text("Create"),
    );

    children.add(Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: createButton,
    ));

    return Form(
      key: formKey,
      child: Column(children: children),
    );
  }
}
