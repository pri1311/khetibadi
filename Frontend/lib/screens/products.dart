import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class productScreen extends StatefulWidget {
  @override
  _productScreenState createState() => _productScreenState();
}

class _productScreenState extends State<productScreen> {
  var index = -1;
  var data;

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
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final url = 'http://10.0.2.2:5000/lol';
    final response = await http.post(
      url,
      body: json.encode({'sentence': "lol"}),
    );
    final decoded = json.decode(response.body) as Map<String, dynamic>;

    data = decoded['data'];
    print(data);
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
                productDetailCard(
                    name: data[0]['name'],
                    price: data[0]['price'],
                    seller: data[0]['seller'],
                    link: data[0]['link']),
                productDetailCard(
                    name: data[1]['name'],
                    price: data[1]['price'],
                    seller: data[1]['seller'],
                    link: data[1]['link']),
                productDetailCard(
                    name: data[2]['name'],
                    price: data[2]['price'],
                    seller: data[2]['seller'],
                    link: data[2]['link']),
              ],
            ),
          )),
    );
  }
}

class productDetailCard extends StatelessWidget {
  String name;

  String price;

  String seller;

  String link;
  productDetailCard({this.name, this.price, this.seller, this.link});

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Material(
              borderRadius: BorderRadius.circular(15.0),
              elevation: 10.0,
              color: Colors.grey[800],
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: c_width,
                              child: Text(
                                name,
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              price,
                              softWrap: true,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              seller,
                              softWrap: true,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: c_width,
                              child: Text(
                                link,
                                softWrap: true,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
