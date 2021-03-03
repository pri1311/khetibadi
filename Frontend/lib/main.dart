import 'package:flutter/material.dart';
import 'package:khetibaadi/screens/card.dart';
// import 'package:khetibaadi/screens/home_screen.dart';
import 'package:khetibaadi/screens/home.dart';

import 'package:khetibaadi/screens/language.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        home: Language(),
        //theme: ThemeData(),
      ),
    );
  }
}
