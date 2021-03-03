import 'package:flutter/material.dart';
import 'package:khetibaadi/constants.dart';
import 'package:khetibaadi/main.dart';
import 'package:khetibaadi/screens/home.dart';
import 'package:khetibaadi/screens/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Language extends StatefulWidget {
  static String dropDownValue;
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String id = 'language';
  SharedPreferences prefs;

  bool _seen;
  List<bool> arr = [false, false, false, false, false, false];
  void checkFirstSeen() async {
    prefs = await SharedPreferences.getInstance();
    _seen = (prefs.getBool('seen') ?? true);

    if (_seen == false) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => HomeScreen())); //change this to home screen
    }
  }

  void listColour(int index) {
    for (int i = 0; i < 6; i++) {
      arr[i] = false;
    }
    arr[index] = true;
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Kheti ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                        ),
                      ),
                      Text(
                        'Baadi',
                        style: TextStyle(
                          color: Color(0xFFFF8532),
                          fontSize: 35.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
                    child: Text(
                      'Growing In?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      children: List.generate(6, (int index) {
                        return Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Container(
                            child: LangButton(
                              onPressed: () {
                                setState(() {
                                  Language.dropDownValue =
                                      languageData[index][1];
                                  listColour(index);
                                });
                              },
                              colour: arr[index]
                                  ? Color(0xFFB2DB5B)
                                  : Color(0xFFFF8532),
                              title: languageData[index][0],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Center(
                    child: RoundedButton(
                        colour: Color(0xFFB2DB5B),
                        title: 'Next',
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (HomeScreen())));
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LangButton extends StatelessWidget {
  LangButton({this.onPressed, this.title, this.colour});
  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colour,
      borderRadius: BorderRadius.circular(10.0),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton({this.colour, this.onPressed, this.title});
  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
