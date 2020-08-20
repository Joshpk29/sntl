import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sntl/TweetCollection.dart';
import 'package:sntl/tweet.dart';
import 'package:twitter_api/twitter_api.dart'; // used to hep do twitter search api, might not need it
import 'package:sentiment_dart/sentiment_dart.dart'; //used for sentiment analysis
import 'package:flutter/foundation.dart';
import 'tweet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Used for the decode
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SNTL',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(245,201,143,1.0)
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
  bool _isVisible = true;
  static String consumerApiKey = "3CSWEz90VoTSuHHQjc7DQgvwQ";
  static String consumerApiSecret = "gTwuNxcnThwDchRZ6cq3nS9VX5Hja8iAWkF6OMnXQaSWza6QdE";
  static String accessToken = "1284682835559944193-tF0gpkzODSpQiJnjevgumsB2i0R40E";
  static String accessTokenSecret = "pUsnhepYa6cRywfFkdNcmgxLPZTXvyXhndp26cTdUIcb9";
  bool isLoading = false;
  Widget waveKit = SpinKitWave(
    color: Color.fromRGBO(245, 201, 143, 1.0),
    size: 50,
  );

  // Creating the twitterApi Object with the secret and public keys
  // These keys are generated from the twitter developer page
  // Dont share the keys with anyone
  final _twitterOauth = new twitterApi(//key information requered for requests to the twitter api
      consumerKey: consumerApiKey,
      consumerSecret: consumerApiSecret,
      token: accessToken,
      tokenSecret: accessTokenSecret
  );

  // Make the request to twitter
  Future searchTweets(String query) async {
    setState(() {
      isLoading = true;
    });
    Future twitterRequest = _twitterOauth.getTwitterRequest(
      // Http Method
      "GET",//GET request
      // Endpoint you are trying to reach
      "search/tweets.json",
      // The options for the request
      options: {
        "q": query,
        "lang": "en",//english
        "count":"100",//100 tweet Max amount for free
        "tweet_mode": "extended",// Used to prevent truncating tweets
      },
    );
    // Wait for the future to finish
    var res = await twitterRequest;//result of the API request

    // Print off the response
    //print(res.statusCode);
    List<tweet> tweetList = new List();//list to hold all tweets
    // Convert the string response into something more useable
    var tweets = json.decode(res.body);//decode the response from the API
      for (int i = 0; i < tweets['statuses'].length; i++) {//look through every collected tweet
        var idValue = tweets['statuses'][i]['full_text'];//Full text of the tweet
        Map tweetValues = sentiment.analysis(idValue, emoji: true, languageCode: 'en');//run sentiment analysis of full text
        tweet curTweet = new tweet(idValue, tweetValues['score'],query);//create new tweet object for TweetCollection
        if(tweetValues['badword'] != null)
          {
            for(int i=0; i<tweetValues['badword'].length; i++){
              if(query.contains(tweetValues['badword'][i][0].toString())) { //search word won't show up in list of bad words
                continue;
              }
              curTweet.setArray(tweetValues['badword'][i][0], tweetValues['badword'][i][1], 0); //add as a negative word used
              }
            }
        if(tweetValues['good words'] != null) {
          for (int i = 0; i < tweetValues['good words'].length; i++) {
            if (query.contains(tweetValues['good words'][i][0].toString())) {//search word wont show up in list of good words
              continue;
            }
            curTweet.setArray(tweetValues['good words'][i][0], tweetValues['good words'][i][1], 1);//add as a positive word used
          }
        }
        tweetList.add(curTweet);//all tweet data collect add to list to display in next pager
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TweetCollection(allTweets: tweetList, searchTerm: query,)));//go to next page
    setState(() {
      isLoading = false;
    });
  }

  TextEditingController controller = new TextEditingController();
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 4001), () {
      setState(() {
        _isVisible = false;
      });
    });
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
    return Material(
      child: Stack(
        children: <Widget>[
          Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                //jello is yummy
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
                      child: !isLoading? RaisedButton(
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
                      ) : waveKit,
                    ),
                  SizedBox(height: 15,)
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: AnimationScreen(
              color: Color.fromRGBO(245,201,143,1.0),
            ),
            ),
        ]
          ),
      );
  }
}
//big ups to Marc at Medium everything from here on is basically him thanks my dude
//here is the link https://www.flutterclutter.dev/flutter/tutorials/beautiful-animated-splash-screen/2020/1108/
class StaggeredRaindropAnimation {
  StaggeredRaindropAnimation(this.controller):

        dropSize = Tween<double>(begin: 0, end: maximumDropSize).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.2, curve: Curves.easeIn),
          ),
        ),

        dropPosition = Tween<double>(begin: 0, end: maximumRelativeDropY).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.2, 0.5, curve: Curves.easeIn),
          ),
        ),

        holeSize = Tween<double>(begin: 0, end: maximumHoleSize).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 1.0, curve: Curves.easeIn),
          ),
        ),

        dropVisible = Tween<bool>(begin: true, end: false).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 0.5),
          ),
        ),
        textOpacity = Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 0.7, curve: Curves.easeOut),
          ),
        );

  final AnimationController controller;

  final Animation<double> dropSize;
  final Animation<double> dropPosition;
  final Animation<bool> dropVisible;
  final Animation<double> holeSize;
  final Animation<double> textOpacity;

  static final double maximumDropSize = 20;
  static final double maximumRelativeDropY = 0.5;
  static final double maximumHoleSize = 10;
}

class AnimationScreen extends StatefulWidget {
  AnimationScreen({
    @required this.color,
  });

  final Color color;

  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  AnimationController _controller;
  StaggeredRaindropAnimation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _animation = StaggeredRaindropAnimation(_controller);
    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                  painter: HolePainter(
                      color: widget.color,
                      holeSize: _animation.holeSize.value * size.width
                  )
              )
          ),
          Positioned(
              top: _animation.dropPosition.value * size.height,
              left: size.width / 2 - _animation.dropSize.value / 2,
              child: SizedBox(
                  width: _animation.dropSize.value,
                  height: _animation.dropSize.value,
                  child: CustomPaint(
                    painter: DropPainter(
                        visible: _animation.dropVisible.value
                    ),
                  )
              )
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                      opacity: _animation.textOpacity.value,
                      child: Text(
                        'SNTL',
                        style: TextStyle(
                            color: Colors.white, fontSize: 32
                        ),
                      )
                  )
              )
          )
        ]
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class DropPainter extends CustomPainter {
  DropPainter({
    this.visible = true
  });

  bool visible;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible) {
      return;
    }

    Path path = new Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(0, size.height * 0.8, size.width / 2, size.height);
    path.quadraticBezierTo(size.width, size.height * 0.8, size.width / 2, 0);
    canvas.drawPath(path, Paint()
      ..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class HolePainter extends CustomPainter {
  HolePainter({
    @required this.color,
    @required this.holeSize,
  });

  Color color;
  double holeSize;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = holeSize / 2;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect outerCircleRect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius);
    Rect innerCircleRect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius / 2);

    Path transparentHole = Path.combine(
      PathOperation.difference,
      Path()..addRect(
          rect
      ),
      Path()
        ..addOval(outerCircleRect)
        ..close(),
    );

    Path halfTransparentRing = Path.combine(
      PathOperation.difference,
      Path()
        ..addOval(outerCircleRect)
        ..close(),
      Path()
        ..addOval(innerCircleRect)
        ..close(),
    );

    canvas.drawPath(transparentHole, Paint()..color = color);
    canvas.drawPath(halfTransparentRing, Paint()..color = color.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


