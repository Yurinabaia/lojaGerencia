import 'package:flutter/material.dart';
//stless
//stfull

class AddDialog extends StatelessWidget {

  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _textController,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text("Add"),
              textColor: Colors.blueAccent,
              onPressed: () {
                Navigator.of(context).pop(_textController.text);
              },
              ),
          )
        ],

        ),
        ),
    );
  }
}