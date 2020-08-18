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
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            //TODO: organize top bar add in gradient background
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromRGBO(245,201,143,1.0),
                  Color.fromRGBO(199,105,238,1.0),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                      Text(widget.searchTerm,textAlign: TextAlign.center, style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 25
                      ),),
                  Text("$sum",textAlign: TextAlign.center,style: TextStyle(
                    color: sum >=0 ? Colors.green : Colors.red,
                    fontSize: 25,
                    fontFamily: 'Courier'
                  ),),
                  Text(widget.allTweets.length.toString(), textAlign: TextAlign.center,style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 15
                  ),),
                  SizedBox(height: 10)
                ],
              ),
            ),
          ),
          Expanded(
            flex:1,
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.allTweets.length,
                itemBuilder: (context, index){
                  return widget.allTweets[index].listItem(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}