import 'package:flutter/material.dart';
class CardScreen extends StatefulWidget {
  static int cardType = 0;
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    if(CardScreen.cardType == 0)
    return Container(
      width: 200,
      child: Center(
        child: Card(
          color: Colors.grey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
               children: <Widget>[
              const ListTile(
                leading: Icon(Icons.language),
                title: Text('Sell to government or in an open mandi?'),
                subtitle: Text('The profit is higher in Mandi including all your travel expenses along with labour work with a profit of 700 Rupees more.'),
              ),
        ],
            ) ),
      ),
    );
    else if (CardScreen.cardType == 1)
      return Container(
        width: 200,
        child: Center(
          child: Card(
              color: Colors.grey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Soil health Laboratories around you?',softWrap: true,),
                    subtitle: Text('Here are the top 2 choices available near you: ',softWrap: true,),
                  ),
                ],
              ) ),
        ),
      );
    else
    return Container(
      width: 200,
      child: Center(
        child: Card(
            color: Colors.grey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.language),
                  title: Text('The actual price cost of cultivation near you.',softWrap: true,),
                  subtitle: Text('Crop1: Price1 ',softWrap: true,),
                ),
              ],
            ) ),
      ),
    );
  }
}
