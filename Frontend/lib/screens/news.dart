import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';

class newsScreen extends StatefulWidget {
  @override
  _newsScreenState createState() => _newsScreenState();
}

class _newsScreenState extends State<newsScreen> {
  var index = -1;
  var data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    final url = 'http://10.0.2.2:5000/lol';
    print('something');
    final response = await http.post(
      url,
      body: json.encode({'sentence': "lol"}),
    );
    setState(() {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      data = decoded['data'];
    });
    print(data);
  }

  bool checkIndex() {
    setState(() {
      index += 1;
    });
    if (index < data.length) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: ListView(
              children: [
                newsCard(
                  title: data[0]['title'],
                  articlebody: data[0]['content'],
                ),
                newsCard(
                  title: data[1]['title'],
                  articlebody: data[1]['content'],
                ),
                newsCard(
                  title: data[2]['title'],
                  articlebody: data[2]['content'],
                ),
              ],
            ),
          )),
    );
  }
}

class newsCard extends StatelessWidget {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();

  String title;
  String articlebody;

  newsCard({this.title, this.articlebody});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ExpansionTileCard(
          key: cardA,
          leading: CircleAvatar(child: Icon(Icons.note)),
          title: Text(title),
          subtitle: Text('Tap to expand!'),
          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(articlebody,
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              buttonHeight: 52.0,
              buttonMinWidth: 90.0,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  onPressed: () {
                    null;
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.mic),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Text('Listen'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
