import 'package:flutter/material.dart';

//stless
//stfull

class InputField extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool obscuro;
  final Stream<String> stream;
  final Function(String) onChange;

  InputField({this.icon, this.text, this.obscuro, this.stream, this.onChange});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
    stream: stream,
    builder: (context, snapshot) {
    return TextField(
      onChanged: onChange,
      decoration: InputDecoration(
        icon: Icon(icon, color:  Colors.white,),
        hintText: text,
        hintStyle: TextStyle(color : Colors.white),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent)
        ),
        contentPadding: EdgeInsets.only(
          left: 5, 
          right: 30,
          bottom: 33,
          top: 30
          ),
          errorText: snapshot.hasError ? snapshot.error : null,
      ),
      style: TextStyle(color: Colors.white),
      obscureText: obscuro,
    );
    }
    );
  }
}