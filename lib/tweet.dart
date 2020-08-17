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
  tweet(String t, int v){
    Tweet = t;
    value = v;
  }
  void setArray(String word, int val, int type){
    if(type ==0)//set bad words
      {
        badWords.add(word);
        badWordsVal.add(val);
    }
    else{ //set good words
      goodWords.add(word);
      goodWordsVal.add(val);
    }
  }
  int sumVals(){
    int sum =0;
    for(int i=0; i<badWordsVal.length; i++)
      {
        sum += badWordsVal[i];
      }
    for(int i=0; i<goodWordsVal.length; i++){
      sum += goodWordsVal[i];
    }
    return sum;
  }
  //TODO: build list component
  //TODO: build Tweet specifics page
  Widget tweetAnalysisPage(BuildContext context){
    return Scaffold(
    );
  }
}