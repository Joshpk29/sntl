//each tweet will be treated as an object and then data can be assigned and used as needed

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class tweet extends StatelessWidget {
  String Tweet;
  int value;
  String searchVal;
  var badWords = new List();
  var badWordsVal = new List();
  var goodWords = new List();
  var goodWordsVal = new List();
  tweet(String t, int v, String searchV){
    Tweet = t;
    value = v;
    searchVal = searchV;
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
  //no longer factors search word into value(i.e childish Gambino -> childish = -2 which kept hurting the value or fuck is -6 so every search would aways be down 6 more that needed)
  int sumVals(){
    int sum =0;
    for(int i=0; i<badWordsVal.length; i++)
      {
        if(searchVal.contains(badWords[i].toString()))
          continue;
        sum += badWordsVal[i];
      }
    for(int i=0; i<goodWordsVal.length; i++){
      if(searchVal.contains(goodWords[i].toString()))
        continue;
      sum += goodWordsVal[i];
    }
    value = sum;
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
                        fontFamily: 'Courier',
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
                      Text("Good Words", style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 20,
                        fontWeight: FontWeight.w300
                      ),),
                        Expanded(
                          flex:goodWords.length+1,
                      child: Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width*.02),
                        child: ListView.builder(
                          itemCount: goodWords.length,
                          itemBuilder: (context,index){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(goodWords[index], style: TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 17
                                ),),
                                Text(goodWordsVal[index].toString(), style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'Courier',
                                  fontSize: 17
                                ),
                                )
                              ],
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Bad Words",style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 20,
                        fontWeight: FontWeight.w300
                    ),),
                    Expanded(
                      flex:badWords.length+1,
                      child: Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width*.02),
                        child: ListView.builder(
                          itemCount: badWords.length,
                          itemBuilder: (context,index){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(badWords[index],style: TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 17
                                ),),
                                Text(badWordsVal[index].toString(),style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Courier',
                                    fontSize: 17
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