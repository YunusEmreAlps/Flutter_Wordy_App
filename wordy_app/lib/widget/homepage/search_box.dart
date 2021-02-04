import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:wordy_app/util/app_constant.dart';
import 'package:wordy_app/util/app_widget.dart';
import 'package:wordy_app/util/screen_util.dart';

class SearchBox extends StatefulWidget {
  final bool isKeyboardVisible;
  final bool isScrollSearchBody;
  final double searchBoxScrollPosition;
  final FocusNode focusNode;

  SearchBox(
      {this.isKeyboardVisible,
      this.focusNode,
      this.isScrollSearchBody,
      this.searchBoxScrollPosition});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  // API Connection
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "de786c9f9472c668ab923c22ea8ce9c02a1e709b";

  TextEditingController searchController = TextEditingController();
  StreamController _streamController;
  Stream _stream;
  Timer _debounce;

  _search() async {
    if (searchController.text == null || searchController.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response response = await get(_url + searchController.text.trim(),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController searchController = TextEditingController();
    return AnimatedPositioned(
      duration: Duration(milliseconds: !widget.isKeyboardVisible ? 220 : 0),
      top: widget.isKeyboardVisible
          ? widget.searchBoxScrollPosition
          : ScreenUtil.getHeight(context) * .35 - 26,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 220),
        opacity:
            !widget.isScrollSearchBody && widget.isKeyboardVisible ? 0.0 : 1.0,
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
                        color: widget.isKeyboardVisible
                            ? Color(0xFFF3A5B1)
                            : Colors.transparent),
                    boxShadow: [
                      !widget.isKeyboardVisible
                          ? BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5.0,
                              offset: Offset(0, 10))
                          : BoxShadow(
                              color: AppConstant.colorPrimary.withOpacity(0.1),
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
                          focusNode: widget.focusNode,
                          onChanged: (String text) {
                            if (_debounce?.isActive ?? false)
                              _debounce.cancel();
                            _debounce =
                                Timer(const Duration(milliseconds: 1000), () {
                              _search();
                            });
                          },
                          controller: searchController,
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
                      widget.isKeyboardVisible
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: AppConstant.colorBackButton,
                                size: 20,
                              ),
                              onPressed: () {
                                searchController.text = "";
                              },
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
            widget.isKeyboardVisible
                ? AnimatedOpacity(
                    opacity: !widget.isKeyboardVisible ? 0.0 : 1.0,
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
    );
  }
}