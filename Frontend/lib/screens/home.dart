import 'package:flutter/material.dart';
import 'package:khetibaadi/screens/card.dart';
import 'package:khetibaadi/screens/mandiPrice.dart';
import 'package:khetibaadi/screens/news.dart';
import 'package:khetibaadi/screens/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:khetibaadi/screens/language.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';

class HomeScreen extends StatefulWidget {
  static String lang = "en";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasSpeech = false;
  double level = 0.0;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  SpeechToText speech = SpeechToText();

  var translatedText = "Translated Text";
  var inputText;
  var identifiedLang = "Detected Language";
  String translateTo;
  final inputTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeSpeechState();
  }

  void initializeSpeechState() async {
    hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (!mounted) return;
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg}";
      // _displayError();
    });
  }

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  void startListening(String translateFrom) {
    print('started');
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 60),
        localeId: translateFrom,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
    print(lastWords);
  }

  void getLanguage() async {
    inputText = inputTextController.text;
    var result = await FirebaseLanguage.instance
        .languageIdentifier()
        .processText(inputText);

    setState(() {
      identifiedLang = result[0].languageCode; //returns most probable
    });
  }

  void getTranslation() async {
    inputText = inputTextController.text;
    print(inputText);
    var result = await FirebaseLanguage.instance
        .languageTranslator(identifiedLang, Language.dropDownValue)
        .processText(inputText);

    setState(() {
      translatedText = result;
    });
  }

  Color blue1 = Color(0xFFFF8532);
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
              padding:
                  EdgeInsets.only(top: 40.0, right: 20, left: 20, bottom: 20),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'What\'s Growing?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      iconButton(icon: Icons.language, onPressed: () {}),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Latest News",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        final url = 'http://10.0.2.2:5000/web';
                        final response = await http.post(
                          url,
                          body: json.encode({'sentence': "news"}),
                        );
                        final decoded =
                            json.decode(response.body) as Map<String, dynamic>;
                        if (decoded['status']['type'] == 'success') {
                          if (decoded['status']['data'] == 0) {
                            print("hello");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (newsScreen())));
                          }
                        }
                        //Navigate to news page
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() async {
                              if (!hasSpeech || speech.isListening == false) {
                                startListening('en');
                              }
                              getLanguage();
                              getTranslation();
                              final url = 'http://10.0.2.2:5000/web';
                              final response = await http.post(
                                url,
                                body: json.encode({'sentence': translatedText}),
                              );
                              final decoded = json.decode(response.body)
                                  as Map<String, dynamic>;
                              print(decoded['status']['type']);
                              if (decoded['status']['type'] == 'success') {
                                if (decoded['status']['data'] == 3) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              (productScreen())));
                                }
                                if (decoded['status']['data'] == 6) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              (mandiPriceScreen())));
                                }

                                if (decoded['status']['data'] == 0) {
                                  print("hello");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              (newsScreen())));
                                }
                              }
                              ;
                            });
                          }),
                      labelText: 'Text Input',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onSubmitted: (value) async {
                      final url = 'http://10.0.2.2:5000/web';
                      final response = await http.post(
                        url,
                        body: json.encode({'sentence': value}),
                      );
                      final decoded =
                          json.decode(response.body) as Map<String, dynamic>;
                      print(decoded['status']['type']);
                      if (decoded['status']['type'] == 'success') {
                        print(decoded['status']['data']);
                        if (decoded['status']['data'] == 3) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (productScreen())));
                        } else if (decoded['status']['data'] == 6) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (mandiPriceScreen())));
                        } else if (decoded['status']['data'] == 0) {
                          print('insidie ');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (newsScreen())));
                        }
                      }
                      ;
                    },
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Recommendations >",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
                    child: Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/3.png'))),
                              width: 250,
                              child: FlatButton(
                                onPressed: () {
                                  CardScreen.cardType = 0;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CardScreen()));
                                },
                                child: Text(
                                  "Calculate whether it is better to sell to govt at MSP or in open mandi in your town.",
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/2.png'))),
                              width: 250,
                              child: FlatButton(
                                onPressed: () {
                                  CardScreen.cardType = 1;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CardScreen()));
                                  //call card
                                },
                                child: Text(
                                  "Know the soil health checking laboratories around you!",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/1.png'))),
                              width: 250,
                              child: FlatButton(
                                onPressed: () {
                                  CardScreen.cardType = 2;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CardScreen()));
                                  //call card
                                },
                                child: Text(
                                  "Know the actual price cost of cultivation in your town!",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButton({
    IconData icon,
    Function onPressed,
  }) {
    return Material(
      shape: CircleBorder(),
      elevation: 5,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: Center(
          child: IconButton(
            splashColor: blue1,
            iconSize: 25,
            color: blue1,
            icon: Icon(icon),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
