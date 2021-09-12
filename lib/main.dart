import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() => runApp(TimerApp());

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  static const duration = const Duration(seconds: 1);

  int minutes = 0;
  int secondsPassed = 0;
  bool isActive = false;
  Timer timer;

  void handleTick() {
    if (isActive) {
      setState(() {
        secondsPassed = secondsPassed - 1;
        if (secondsPassed == -1) {
          setState(() {
            isActive = !isActive;
            secondsPassed = 0;
          });
        }
      });
    }
  }

  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
    int seconds = secondsPassed % 60;
    int minutes = secondsPassed ~/ 60;
    int hours = secondsPassed ~/ (60 * 60);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            backgroundColor: Colors.blue[400],
            title: Center(
              child: Text('Timer'),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    hintText: 'Enter time in minutes',
                    labelText: 'Enter time in minutes',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: clearText,
                    ),
                  ),
                  controller: fieldText,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (text) {
                    setState(() {
                      secondsPassed = int.parse(text) * 60;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LabelText(
                      label: 'HRS',
                      value: hours.toString().padLeft(2, '0'),
                    ),
                    LabelText(
                      label: 'MIN',
                      value: minutes.toString().padLeft(2, '0'),
                    ),
                    LabelText(
                      label: 'SEC',
                      value: seconds.toString().padLeft(2, '0'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 47,
                  margin: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    color: Color.fromRGBO(0, 0, 255, 100),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(isActive ? 'Pause' : 'START'),
                    onPressed: () {
                      setState(() {
                        isActive = !isActive;
                      });
                    },
                  ),
                ),
                Container(
                  width: 200,
                  height: 47,
                  margin: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    color: Color.fromRGBO(0, 0, 255, 100),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Text("Stop and Reset"),
                    onPressed: () {
                      setState(() {
                        secondsPassed = 0;
                        isActive = !isActive;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class LabelText extends StatelessWidget {
  LabelText({this.label, this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.blue,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
                color: Colors.white, fontSize: 55, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
