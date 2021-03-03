import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class mandiPriceScreen extends StatefulWidget {
  @override
  _mandiPriceScreenState createState() => _mandiPriceScreenState();
}

class _mandiPriceScreenState extends State<mandiPriceScreen> {
  var index = -1;
  var data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    final url = 'http://10.0.2.2:5000/lol';
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
                mandiPrices(
                    commodity: data[0]['name'],
                    variety: data[0]['variety'],
                    marketCentre: data[0]['market'],
                    modalPrice: data[0]['modalPrice']),
                mandiPrices(
                    commodity: data[1]['name'],
                    variety: data[1]['variety'],
                    marketCentre: data[1]['market'],
                    modalPrice: data[1]['modalPrice']),
                mandiPrices(
                    commodity: data[2]['name'],
                    variety: data[2]['variety'],
                    marketCentre: data[2]['market'],
                    modalPrice: data[2]['modalPrice']),
                mandiPrices(
                    commodity: data[2]['name'],
                    variety: data[2]['variety'],
                    marketCentre: data[2]['market'],
                    modalPrice: data[2]['modalPrice']),
              ],
            ),
          )),
    );
  }
}

class mandiPrices extends StatelessWidget {
  String commodity;
  String marketCentre;
  String variety;
  String modalPrice;

  mandiPrices(
      {this.commodity, this.marketCentre, this.variety, this.modalPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.grey[800],
        child: Material(
          borderRadius: BorderRadius.circular(15.0),
          elevation: 10.0,
          color: Colors.grey[800],
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Commodity: " + commodity,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Place: " + marketCentre,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Variety: " + variety,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Modal Price: " + modalPrice,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
