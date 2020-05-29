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

  String _roomId = "178001984";
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Lsnetchatplugin.initChatUtil("9bb7a8db4c47bef4c1300d02ddc624a2");
    initPlatformState();

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
              TextField(
                  controller: _controller,
                ),
              Text("用户：$_userData"),
              MaterialButton(
                onPressed: () {
//                  Lsnetchatplugin.login(
//                          "lm123456789", "5e15369debb7230611b81dd65bf05d92")
//                      .then((data) {
//                    setState(() {
//                      _userData = "登录${data.message}";
//                    });
//                  });
                  Lsnetchatplugin.login(
                      "betayyt_814", "ad7d35f932208fa3ad182963b9757c0b")
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
//                  Lsnetchatplugin.enterChatRoom(_roomId, "信陵公子").then((data){
//                    print("enterChatRoom:${data}");
//                  });
                  Lsnetchatplugin.enterRoomWithOutLogin(_roomId, "url");
                },
                child: Text("独立进入聊天室"),
              ),
              MaterialButton(
                onPressed: () {
                  Lsnetchatplugin.enterChatRoom(_roomId, "面对疾风吧").then((data){
                    print("enterChatRoom:${data}");
                  });

                },
                child: Text("非独立进入聊天室"),
              ),
              MaterialButton(
                onPressed: () {
                  Lsnetchatplugin.exitChatRoom(_roomId);
                },
                child: Text("退出聊天室"),
              ),
              MaterialButton(
                onPressed: () {
                  Lsnetchatplugin.getRoomInfo(_roomId).then((data){
                    print("getRoomInfo:${data.onlineUserCount}");
                  });
                },
                child: Text("查询聊天室信息"),
              ),
              MaterialButton(
                onPressed: () {
                  Lsnetchatplugin.sendTextMessage(_controller.text,_roomId,"樱桃大丸子");
//                  print(_controller.text);

                 // Lsnetchatplugin.stopPlayer(_roomId);

                },
                child: Text("发送消息"),
              ),
              MaterialButton(
                onPressed: () {
//                  Lsnetchatplugin.sendTextMessage(_controller.text,_roomId,"樱桃大丸子");
//                  print(_controller.text);
                  Lsnetchatplugin.stopPlayer(_roomId);
                },
                child: Text("退出直播消息"),
              ),
              MaterialButton(
                onPressed: () {
                  Lsnetchatplugin.logout().then((data) {
                    setState(() {
                      _userData = "登出${data}";
                    });
                  });
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
