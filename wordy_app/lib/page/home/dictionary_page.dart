import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wordy_app/util/app_widget.dart';
import 'package:wordy_app/page/word_detail_page.dart';
import 'package:wordy_app/util/app_constant.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  bool isKeyboardVisible;
  PageController _pageController = PageController(initialPage: 0);
  bool isEmpty = false;

  // API Connection
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "de786c9f9472c668ab923c22ea8ce9c02a1e709b";

  TextEditingController _controller = TextEditingController();
  StreamController _streamController;
  Stream _stream;
  Timer _debounce;

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response response = await get(_url + _controller.text.trim(),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.vertical > 0;
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
          'Dictionary',
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isKeyboardVisible
                              ? Color(0xFFF3A5B1)
                              : Colors.transparent),
                      boxShadow: [
                        isKeyboardVisible
                            ? BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5.0,
                                offset: Offset(0, 10))
                            : BoxShadow(
                                color:
                                    AppConstant.colorPrimary.withOpacity(0.1),
                                offset: Offset(0, 0),
                                blurRadius: 3,
                                spreadRadius: 1)
                      ]),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Theme(
                    data: AppWidget.getThemeData()
                        .copyWith(primaryColor: Colors.grey),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            onChanged: (String text) {
                              if (_debounce?.isActive ?? false)
                                _debounce.cancel();
                              _debounce =
                                  Timer(const Duration(milliseconds: 1000), () {
                                _search();
                              });
                            },
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppConstant.colorBackButton),
                              //
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Container(
                                margin: EdgeInsets.only(bottom: 0),
                                child: Icon(
                                  Icons.search,
                                  color: AppConstant.colorBackButton,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        isKeyboardVisible
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: AppConstant.colorBackButton,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _controller.text = "";
                                },
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
              isKeyboardVisible
                  ? AnimatedOpacity(
                      opacity: !isKeyboardVisible ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                        margin: EdgeInsets.only(right: 16),
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Container(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, right: 4, left: 4),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: AppConstant.colorHeading,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Enter a search word"),
              );
            }

            if (snapshot.data == "waiting") {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data["definitions"].length,
              itemBuilder: (BuildContext context, int index) {
                return ListBody(
                  children: <Widget>[
                    Container(
                      child: ListTile(
                        title: _historyItem(
                            title: _controller.text.trim(), 
                            type: snapshot.data["definitions"][index]["type"],
                            desc: snapshot.data["definitions"][index]
                                ["definition"]),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _renderEmptyState() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.history,
            size: 48,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'It\'s quite lonely here...',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.colorParagraph2),
          ),
        ],
      ),
    );
  }

  Widget _historyItem(
    {@required String title, @required String type, @required String desc}) {
    title = title[0].toUpperCase() + title.substring(1);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => WordDetailPage('$title', '$type', '$desc')));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$title'+ " (" + '$type' + ")",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstant.colorPrimary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
