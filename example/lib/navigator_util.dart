import 'package:flutter/cupertino.dart';

class NavigagatorUtil {
  static void pushPage(BuildContext context, Widget page)  {
    if (context == null || page == null) {
      return;
    }

    Navigator.push(context, new CupertinoPageRoute<void>(builder: (ctx) => page));
  }

  static dynamic pushPageResult(BuildContext context, Widget page) async{

    return await Navigator.push(context, new CupertinoPageRoute<void>(builder: (ctx) => page));;

  }
}
