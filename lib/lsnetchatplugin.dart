import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Lsnetchatplugin {
  static const MethodChannel _channel = const MethodChannel('lsnetchatplugin');
  static const EventChannel _eventChannel =
      const EventChannel('lsnetchatplugin');
  ValueChanged<String> messageListener;
  ///初始化聊天工具
  initChatUtil() {
    _channel.invokeMethod("initChatUtil");
  }

  ///登陆
  Future login(String account, String token) =>
      _channel.invokeMethod("login", {"account": account, "token": token});

  ///进入聊天室
  Future enterChatRoom(String roomId) =>
      _channel.invokeMethod("enterChatRoom", {"roomId": roomId});

  ///退出聊天室
  Future exitChatRoom(String roomId)=>_channel.invokeMethod("exitChatRoom",{"roomId": roomId});

  ///发送文字消息
  Future sendTextMessage(String message)=>_channel.invokeMethod("sendTextMessage",{"message":message});

  ///添加会话消息监听
  Future addListener(ValueChanged<String> messageListener) async{
    this.messageListener = messageListener;
    _eventChannel.receiveBroadcastStream().listen((data){
      messageListener?.call(data);
    });
    await _channel.invokeMethod("messageListener");
  }

  ///移除监听
  Future removeListener() async {
    this.messageListener = null;
    await _channel.invokeMethod("removeMessageListener");
  }

  ///获取房间信息
  Future getRoomInfo(String message)=> _channel.invokeMethod("roomInfo",{"message":message});

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
