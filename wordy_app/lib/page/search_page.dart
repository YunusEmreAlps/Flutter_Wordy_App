import 'package:flutter/material.dart';
import 'package:wordy_app/util/fade_animation.dart';
import 'package:wordy_app/widget/searchpage/history_body_list.dart';
import 'package:wordy_app/widget/searchpage/vowels.dart';


class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.3,
      Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Vowels(),
              HistoryBodyList(
                historyWord: 'Eagle',
              )
            ],
          )
        ],
      ),
    );
  }
}
