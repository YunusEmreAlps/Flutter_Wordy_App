import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordy_app/data/word.dart';
import 'package:wordy_app/data/words.dart';
import 'package:wordy_app/util/app_constant.dart';
import 'package:wordy_app/sqlite/db_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LearnWordsPage extends StatefulWidget {
  @override
  _LearnWordsPageState createState() => _LearnWordsPageState();
}

class _LearnWordsPageState extends State<LearnWordsPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FlutterTts flutterTts = FlutterTts();
  bool isEmpty = false;

  var randomWordList = [];

  @override
  void initState() {
    super.initState();
    randomWordList = shuffle(WordData.greData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: PageView.builder(
        itemBuilder: (context, position) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  randomWordList[position].wordTitle[0].toUpperCase() + randomWordList[position].wordTitle.substring(1),
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                      color: AppConstant.colorParagraph),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Material(
                                  color: Colors.white,
                                  elevation: 4,
                                  shadowColor: Colors.black38,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                randomWordList[position]
                                                    .wordDefinition,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "Swipe Up",
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.black38,
                        child: InkWell(
                          onTap: () {
                            _speakWord(randomWordList[position].wordTitle);
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 48,
                            width: 48,
                            child: Center(child: Icon(Icons.settings_voice)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.black38,
                        child: InkWell(
                          onTap: () {
                            _addWord(
                              Word(randomWordList[position].wordTitle,
                                  randomWordList[position].wordDefinition),
                            );
                            scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Word Added!")));
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            height: 48,
                            width: 48,
                            child: Center(
                                child: Icon(
                              Icons.bookmark,
                              color: AppConstant.colorPrimary,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
        scrollDirection: Axis.vertical,
        itemCount: randomWordList.length,
      ),
    );
  }

  void _addWord(Word word) {
    DBProvider.db.insertWord(word);
  }

  void _speakWord(String word) async {
    await flutterTts.speak(word);
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
}
