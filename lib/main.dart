import 'package:flutter/material.dart';
import 'package:sntl/TweetCollection.dart';
import 'package:sntl/tweet.dart';
import 'package:twitter_api/twitter_api.dart'; // used to hep do twitter search api, might not need it
import 'package:sentiment_dart/sentiment_dart.dart'; //used for sentiment analysis
import 'package:flutter/foundation.dart';
import 'tweet.dart';

// Used for the decode
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SNTL',
      theme: ThemeData(
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final sentiment = Sentiment();
  static String consumerApiKey = "3CSWEz90VoTSuHHQjc7DQgvwQ";
  static String consumerApiSecret = "gTwuNxcnThwDchRZ6cq3nS9VX5Hja8iAWkF6OMnXQaSWza6QdE";
  static String accessToken = "1284682835559944193-tF0gpkzODSpQiJnjevgumsB2i0R40E";
  static String accessTokenSecret = "pUsnhepYa6cRywfFkdNcmgxLPZTXvyXhndp26cTdUIcb9";

  // Creating the twitterApi Object with the secret and public keys
  // These keys are generated from the twitter developer page
  // Dont share the keys with anyone
  final _twitterOauth = new twitterApi(
      consumerKey: consumerApiKey,
      consumerSecret: consumerApiSecret,
      token: accessToken,
      tokenSecret: accessTokenSecret
  );

  // Make the request to twitter
  Future searchTweets(String query) async {
    Future twitterRequest = _twitterOauth.getTwitterRequest(
      // Http Method
      "GET",
      // Endpoint you are trying to reach
      "search/tweets.json",
      // The options for the request
      options: {
        "q": query,
        "lang": "en",
        "count":"100",
        "tweet_mode": "extended",// Used to prevent truncating tweets
      },
    );
    // Wait for the future to finish
    var res = await twitterRequest;

    // Print off the response
    //print(res.statusCode);
    List<tweet> tweetList = new List();
    // Convert the string response into something more useable
    var tweets = json.decode(res.body);
      for (int i = 0; i < tweets['statuses'].length; i++) {
        var idValue = tweets['statuses'][i]['full_text'];
        Map tweetValues = sentiment.analysis(idValue, emoji: true, languageCode: 'en');
        tweet curTweet = new tweet(idValue, tweetValues['score']);
        if(tweetValues['badword'] != null)
          {
            for(int i=0; i<tweetValues['badword'].length; i++)
              curTweet.setArray(tweetValues['badword'][i][0], tweetValues['badword'][i][1], 0);
          }
        if(tweetValues['good words'] != null){
          for(int i=0; i<tweetValues['good words'].length; i++)
            curTweet.setArray(tweetValues['good words'][i][0], tweetValues['good words'][i][1], 1);
        }
        tweetList.add(curTweet);
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TweetCollection(allTweets: tweetList, searchTerm: query,)));
  }


  TextEditingController controller = new TextEditingController();
  void initState() {
    super.initState();
    controller.addListener(() {
      final text = controller.text.toLowerCase();
      controller.value = controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 100),
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Courier'
                ),
                decoration: InputDecoration(
                  hintText: "Enter Search Term",
                  hintStyle: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Courier'
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: Text("Breakdown of the peoples' ideas",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Courier'
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  onPressed: (){
                    searchTweets(controller.text);
                  },
                  elevation: 6,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                     gradient: LinearGradient(
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromRGBO(245,201,143,1.0),
                        Color.fromRGBO(199,105,238,1.0),
                      ],
                     ),
                    ),
                    padding: const EdgeInsets.all(30.0),
                    child: const Text(">",textAlign: TextAlign.center, style: TextStyle(fontSize: 48,fontFamily: 'Courier'),),
                  ),
                  shape: CircleBorder(
                      side: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            SizedBox(height: 15,)
          ],
        ),
      ),
    );
  }
}
