import 'package:Beacon_app/models/global.dart';
import 'package:flutter/material.dart';
import 'package:Beacon_app/UI/Intray/intray_page.dart';

class IntrayTodo extends StatelessWidget {
  final String title;
  final String deadline;
  final String keyValue;
  IntrayTodo({this.keyValue, this.title, this.deadline});
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(keyValue),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[200], Colors.grey[300]]),
          boxShadow: [
            new BoxShadow(color: Colors.yellow.withOpacity(0.5), blurRadius: 10)
          ]),
      child: Row(
        children: <Widget>[
          Radio(),
          Column(
            children: [
              Center(
                child: Text(
                  deadline,
                  style: pluckLightDateStyle,
                ),
              ),
              Center(
                child: Text(
                  title,
                  style: pluckLightTitleStyle,
                ),
              ),
            ],
          )
        ],
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(30),
      height: 200,
    );
  }
}
