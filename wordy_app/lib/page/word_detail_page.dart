import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordy_app/data/word.dart';
import 'package:wordy_app/data/words.dart';
import 'package:wordy_app/util/app_constant.dart';
import 'package:wordy_app/sqlite/db_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordDetailPage extends StatefulWidget {
  final String title;
  final String type;
  final String desc;

  WordDetailPage(this.title, this.type, this.desc);
  @override
  _WordDetailPageState createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FlutterTts flutterTts = FlutterTts();
  bool isEmpty = false;
  bool isKeyboardVisible;
  int _selectedCategory = 0;
  PageController _pageController = PageController(initialPage: 0);

  var randomWordList = [];

  @override
  void initState() {
    super.initState();
    randomWordList = shuffle(WordData.greData);
  }

  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.vertical > 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppConstant.colorHeading,
          ),
        ),
        elevation: 0,
        backgroundColor: AppConstant.colorPageBg,
        title: Text(
          widget.title,
          style: TextStyle(color: AppConstant.colorHeading),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: AppConstant.colorHeading,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title[0].toUpperCase() +
                              widget.title.substring(1),
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Material(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.white,
                                  elevation: 4,
                                  shadowColor: Colors.black38,
                                  child: InkWell(
                                    onTap: () {
                                      _speakWord(widget.title);
                                    },
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      height: 48,
                                      width: 48,
                                      child: Center(
                                          child: Icon(Icons.settings_voice)),
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
                                        Word(
                                            widget.title,
                                            widget.desc),
                                      );
                                      scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text("Word Added!")));
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
                                )
                              ],
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white,
                              elevation: 4,
                              shadowColor: Colors.black38,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      'Wordy',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppConstant.colorParagraph2),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
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
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '1',
                                      style: TextStyle(
                                          color: AppConstant.colorParagraph2),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      widget.type.toUpperCase(),
                                      style: TextStyle(
                                        color: AppConstant.colorPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: Text(
                                            widget.desc,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppConstant.colorParagraph),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
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
