import 'package:flutter/material.dart';
import 'system_screen_util.dart';
import 'package:clock_in_map/clock_in_map.dart';
/// 搜索 地址 页面
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<Tip> tipList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          buildSearchTitle(),
          Container(
            height: 0.5,
            color: Color(0xFFE5E5E5),
          ),
          buildRootList()
        ],
      ),
    );
  }

  // 搜索框
  Widget buildSearchTitle() {
    return SizedBox(
      height: 44 + SystemScreenUtil.getStatusBarH(context),
      child: PreferredSize(
        preferredSize:
            Size.fromHeight(44 + SystemScreenUtil.getStatusBarH(context)),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            width: SystemScreenUtil.getInstance().screenWidth,
            padding:
                EdgeInsets.only(top: SystemScreenUtil.getStatusBarH(context)),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      height: 44,
                      child: Row(
                        children: <Widget>[
                          /// 左边 图片 按钮
                          GestureDetector(
                            child: Container(
                              color: Colors.transparent,
                              height: 44,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 17,
                                  right: 16,
                                ),
                                child: Image.asset(
                                  'assets/images/back.png',
                                  width: 10,
                                  height: 18,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
//                              NavigatorUtils.goBack(context);
                            },
                          ),

                          /// 搜索框
                          Expanded(
                            child: Container(
                              height: 28,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(33),
                                  color: Color(0xFFF4F4F4)),
                              child: Row(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: 14)),
                                  Image.asset(
                                    'assets/images/home_icon_search.png',
                                    width: 13,
                                    height: 13,
                                    color: Color(0xFF999999),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _controller,
                                      autofocus: true,
                                      textInputAction: TextInputAction.search,
                                      focusNode: _focusNode,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      cursorWidth: 1,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF333333)),
                                      decoration: InputDecoration(
                                          hintText: '搜索地址',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF999999)),
                                          fillColor: Color(0xFFF4F4F4),
                                          filled: true,
                                          contentPadding: EdgeInsets.only(
                                              top: 5.5,
                                              bottom: 5.5,
                                              left: 8,
                                              right: 15),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(33),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(33),
                                          )),
                                      onSubmitted: (String str) {
                                        searchClick();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: searchClick,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '搜索',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          //设置没有返回按钮
        ),
      ),
    );
  }

  Widget buildRootList() {
    return Expanded(
        child: ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return buildItem(index);
      },
//      itemCount: 10,
      itemCount: tipList == null ? 0 : tipList.length,
    ));
  }

  Widget buildItem(index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => itemClick(index),
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tipList[index].name,
                style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
              SizedBox(
                height: 5,
              ),
              Text('${tipList[index].district}${tipList[index].address}',
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 0.5,
                color: Color(0xFFE5E5E5),
              )
            ],
          ),
        ),
      ),
    );
  }

  void searchClick() {
    if (_controller.text.isNotEmpty) {
      print('${_controller.text}');
      CIMSearch.searchAddress(_controller.text).then((list){
        if(tipList == null){
          tipList = new List();

        }else{
          tipList.clear();
        }
        setState(() {
          tipList = list;
        });
      });
    }
  }

  void itemClick(index) {
    Navigator.pop(context,tipList[index].latLonPoint);
  }
}
