// Wordy
import 'package:wordy_app/data/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wordy_app/util/app_constant.dart';
import 'package:wordy_app/sqlite/db_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SavedWordsPage extends StatefulWidget {
  @override
  _SavedWordsPageState createState() => _SavedWordsPageState();
}

class _SavedWordsPageState extends State<SavedWordsPage> {
  PageController _pageController = PageController(initialPage: 0);
   FlutterTts flutterTts = FlutterTts();
  bool isEmpty = false;

  int _selectedCategory = 0;
  List<Word> words;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppConstant.colorHeading,
          ),
        ),
        elevation: 0,
        backgroundColor: AppConstant.colorPageBg,
        title: Text(
          'Saved Words',
          style: TextStyle(color: AppConstant.colorHeading),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.clear,
              color: AppConstant.colorHeading,
            ),
            onPressed: () {
              setState(() {
                isEmpty = !isEmpty;
              });
            },
          )
        ],
        brightness: Brightness.light,
      ),
      body: words == null
          ? CircularProgressIndicator()
          : (words.isEmpty
              ? Center(
                  child: Text(
                    "It's quite lonely here...",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              : _buildPage()),
    );
  }

  Widget _buildPage() {
    return PageView.builder(
      itemBuilder: (context, position) {
        return Container(
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
                            words[position].wordTitle[0].toUpperCase() + words[position].wordTitle.substring(1),
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '',
                            style: TextStyle(color: AppConstant.colorParagraph),
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
                                        _speakWord(
                                            words[position].wordTitle);
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
                                ],
                              ),
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          words[position].wordDefinition,
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
                padding: const EdgeInsets.all(32.0),
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
        );
      },
      scrollDirection: Axis.vertical,
      itemCount: words.length,
    );
  }

  void _speakWord(String word) async {
    await flutterTts.speak(word);
  }

  void _loadWords() async {
    words = await DBProvider.db.getAllWords();
    setState(() {});
  }
}
