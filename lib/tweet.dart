//each tweet will be treated as an object and then data can be assigned and used as needed

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class tweet extends StatelessWidget {
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
  //completely unnessary function dumb ass
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
  Widget listItem(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Material(
        elevation: 8,
        child: ListTile(
          leading: Text(
        "$value",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: value >= 0 ? Colors.green : Colors.red
        ),
          ),
          title: Text(Tweet),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => build(context)));
          },
        ),
      ),
    );
  }
  //TODO: build Tweet specifics page
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*.05),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                      child: Text("Score: $value", textAlign: TextAlign.center,style: TextStyle(
                        color: value>=0? Colors.green : Colors.red,
                        fontSize: 48,
                        fontFamily: 'Courier'
                      ),)
                  ),
                  Text("Full Tweet: "+Tweet,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Courier'
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.03),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10,),
                      Text("Good words"),
                        Expanded(
                          flex:goodWords.length+1,
                      child: Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width*.02),
                        child: ListView.builder(
                          itemCount: goodWords.length,
                          itemBuilder: (context,index){
                            return Row(
                              children: <Widget>[
                                Text(goodWords[index]),
                                Text(goodWordsVal[index].toString(),style: TextStyle(
                                  color: Colors.green
                                ),
                                )
                              ],
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Bad Words"),
                    Expanded(
                      flex:badWords.length+1,
                      child: Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width*.02),
                        child: ListView.builder(
                          itemCount: badWords.length,
                          itemBuilder: (context,index){
                            return Row(
                              children: <Widget>[
                                Text(badWords[index]),
                                Text(badWordsVal[index].toString(),style: TextStyle(
                                    color: Colors.red
                                ),
                                )
                              ],
                            );
                          }),
                      )
                    ),
                      ])
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}