import 'tweet.dart';
import 'package:flutter/material.dart';

class TweetCollection extends StatefulWidget{
  final List<tweet> allTweets;
  final String searchTerm;
  TweetCollection({Key key,  @required this.allTweets, @required this.searchTerm}) : super(key: key);

  @override
  _TweetCollectionState createState() => _TweetCollectionState();
}

class _TweetCollectionState extends State<TweetCollection> {
  @override
  void initState(){
    super.initState();
    totalValue();
  }
  int sum =0;
  void totalValue(){
    for(int i=0; i<widget.allTweets.length; i++){
      sum += widget.allTweets[i].sumVals();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              //TODO: organize top bar add in gradient background
              height: 400,
              child: Column(
                children: <Widget>[
                  Flexible(
                      flex: 2,
                      child: Text(widget.searchTerm,textAlign: TextAlign.center,)),
                  Flexible(
                      flex: 1,
                      child: Text("$sum",textAlign: TextAlign.center,style: TextStyle(
                        color: sum >=0 ? Colors.green : Colors.red
                      ),)),
                  Flexible(
                      flex: 1,
                      child: Text(widget.allTweets.length.toString(), textAlign: TextAlign.center,)),
                ],
              ),
            ),
            //TODO: list all tweets
          ],
        ),
      ),
    );
  }
}