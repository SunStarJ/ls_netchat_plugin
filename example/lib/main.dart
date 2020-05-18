import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lsnetchatplugin/lsnetchatplugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _userData = '';

  @override
  void initState() {
    super.initState();
    Lsnetchatplugin.initChatUtil("8d4f15775c9cb2a2a44fca0025e4c0a0");
    initPlatformState();

    print("111");

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Lsnetchatplugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("用户：$_userData"),
              MaterialButton(
                onPressed: () {
                  Lsnetchatplugin.login(
                          "lm123456789", "5e15369debb7230611b81dd65bf05d92")
                      .then((data) {
                    setState(() {
                      _userData = "登录${data.message}";
                    });
                  });
                },
                child: Text("登陆"),
              ),
              MaterialButton(
                onPressed: () {
                  Lsnetchatplugin.sendTextMessage("123","roomid","樱桃大丸子");
                },
                child: Text("发送消息"),
              ),
              MaterialButton(
                onPressed: () {
                  Lsnetchatplugin.logout().then((data) {
                    setState(() {
                      _userData = "登出${data}";
                    });
                  });

//                  Lsnetchatplugin.logout().whenComplete(() {
//                    setState(() {
//                      _userData = "";
//                    });
//                  });
                },
                child: Text("退出登陆"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
