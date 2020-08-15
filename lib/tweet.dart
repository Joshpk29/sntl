//each tweet will be treated as an object and then data can be assigned and used as needed

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class tweet {
  String Tweet;
  int value;
  var badWords = new List();
  var badWordsVal = new List();
  var goodWords = new List();
  var goodWordsVal = new List();
  tweet(String t, int v, List bw, List bwv, List gw, List gwv){
    Tweet = t;
    value = v;
    badWords = bw;
    badWordsVal = bwv;
    goodWords = gw;
    goodWordsVal = gwv;
  }
  Widget tweetAnalysisPage(BuildContext context){
    return Scaffold(
    );
  }
}