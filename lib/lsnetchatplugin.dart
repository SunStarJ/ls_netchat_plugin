import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Lsnetchatplugin {
  static const MethodChannel _channel = const MethodChannel('lsnetchatplugin');
  static const EventChannel _eventChannel =
      const EventChannel('lsnetchatplugin_e');
  static ValueChanged<String> messageListener;
  ///初始化聊天工具
  static initChatUtil(String appKey) {
    _channel.invokeMethod("initChatUtil",{"appKey":appKey});
  }

  ///登陆
  static Future login(String account, String token) =>
      _channel.invokeMethod("login", {"account": account, "token": token});

  ///进入聊天室
  static Future enterChatRoom(String roomId) =>
      _channel.invokeMethod("enterChatRoom", {"roomId": roomId});

  ///退出聊天室
  static Future exitChatRoom(String roomId)=>_channel.invokeMethod("exitChatRoom",{"roomId": roomId});

  ///发送文字消息
  static Future sendTextMessage(String message)=>_channel.invokeMethod("sendTextMessage",{"message":message});

  ///添加会话消息监听
  static Future addListener(ValueChanged<String> messageListener) async{
    messageListener = messageListener;
    _eventChannel.receiveBroadcastStream().listen((data){
      messageListener?.call(data);
    });
    await _channel.invokeMethod("messageListener");
  }

  ///移除监听
  static Future removeListener() async {
    messageListener = null;
    await _channel.invokeMethod("removeMessageListener");
  }

  ///获取房间信息
  static Future getRoomInfo(String message)=> _channel.invokeMethod("roomInfo",{"message":message});

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
