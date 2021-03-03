import 'package:flutter/material.dart';
import 'package:khetibaadi/screens/mandiPrice.dart';
import 'package:khetibaadi/screens/news.dart';
import 'package:khetibaadi/screens/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';

import '../screens/language.dart';
import '../screens/products.dart';



Color blue1 = Color(0XFFB2DB5B);

class searchBar extends StatefulWidget {
  @override
  _searchBarState createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
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



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TextField(
            style: TextStyle(
              color: blue1,
              fontSize: 20,
            ),
            cursorColor: blue1,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: blue1, width: 1.5)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: blue1, width: 1.5)),
              contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.mic,
                  color: blue1,
                  size: 20,
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
              final decoded =
                  json.decode(response.body) as Map<String, dynamic>;
              if (decoded['status']['type'] == 'success') {
                if (decoded['status']['data'] == 3) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (productScreen())));
                }
                if(decoded['status']['type']==6){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>(mandiPriceScreen())));
                }

                if(decoded['status']['type']==0){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>(newsScreen())));
                }
              };
                  });
                },
              ),
              labelText: lastWords ?? 'Text Input',
              labelStyle: TextStyle(
                fontSize: 20,
                color: blue1,
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
              if (decoded['status']['type'] == 'success') {
                if (decoded['status']['data'] == 3) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (productScreen())));
                }
                if(decoded['status']['type']==6){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>(mandiPriceScreen())));
                }

                if(decoded['status']['type']==0){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>(newsScreen())));
                }
              };
            }),
      ),
    );
  }
}


