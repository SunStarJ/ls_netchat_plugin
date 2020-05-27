import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lsnetchatplugin/login_data.dart';
import 'package:lsnetchatplugin/message_data.dart';

/**
 * 所有的成功回调code都为0，error回调会有不同的错误码和描述
 * */

class Lsnetchatplugin {
  static const MethodChannel _channel = const MethodChannel('lsnetchatplugin');
  static const EventChannel _eventChannel =
      const EventChannel('lsnetchatplugin_e');

  static ValueChanged<List<NIMessage>> messageListener;
  static Function playerStop;

  //eventChannel监听分发中心
  static eventChannelDistribution() {
    _eventChannel.receiveBroadcastStream().listen((data) {
      print(data);
      int type = data["type"];

      switch (type) {
        case 105: //接收到消息
          {
            List<NIMessage> msgList =
                MsgListResult().getResultFromMap(data["data"]);
            messageListener?.call(msgList);
            msgList.forEach((message) {
              if (message.content == "401") {
                playerStop?.call();
              }
            });
          }
          break;

        default:
          print(data["data"]);
          break;
      }
    });
  }

  static initPlayerStopListener(Function playerStop) {
    Lsnetchatplugin.playerStop = playerStop;
  }

  ///初始化聊天工具
  static initChatUtil(String appKey) {
    _channel.invokeMethod("initChatUtil", {"appKey": appKey});
    //初始化的时候添加消息监听（考虑到可能会有其他监听，所以在这儿添加的，目前只有聊天，所以也可以加到添加聊天监听那儿）
    eventChannelDistribution();
  }

  static enterRoomWithOutLogin(String roomId, String url) => _channel
      .invokeMethod("enterChatRoomWithOutLog", {"roomId": roomId,"url":url});

  static LSNetChatPluginMethodChannelResultData dealMethodChannelResultMap(
      Map data) {
    return LSNetChatPluginMethodChannelResultData()
      ..code = data["code"]
      ..message = data["message"];
  }

  ///登陆
  static Future<LSNetChatPluginMethodChannelResultData> login(
          String account, String token) =>
      _channel.invokeMethod("login", {"account": account, "token": token}).then(
          (data) {
        return dealMethodChannelResultMap(data);
      });

  ///退出登陆
  static Future<LSNetChatPluginMethodChannelResultData> logout() =>
      _channel.invokeMethod("logout").then((data) {
        return dealMethodChannelResultMap(data);
      });

  ///进入聊天室
  static Future<LSNetChatPluginMethodChannelResultData> enterChatRoom(
          String roomId, String nicName) =>

      _channel.invokeMethod(
          "enterChatRoom", {"roomId": roomId, "nicName": nicName}).then((data) {
        print(data);

        return dealMethodChannelResultMap(data);
      });

  ///退出聊天室
  static Future<LSNetChatPluginMethodChannelResultData> exitChatRoom(
          String roomId) =>
      _channel.invokeMethod("exitChatRoom", {"roomId": roomId}).then((data) {
        return dealMethodChannelResultMap(data);
      });

  ///发送文字消息
  static Future<LSNetChatPluginMethodChannelResultData> sendTextMessage(
          String message, String roomId, String nicName) =>
      _channel.invokeMethod("sendTextMessage", {
        "message": message,
        "nicName": nicName,
        "roomId": roomId
      }).then((data) {
        return dealMethodChannelResultMap(data);
      });

//  //添加聊天室监听
//  static Future addChatRoomLinkListener() async{
//
//    _channel.invokeMethod("");
//
//  }

//  //添加登录监听
//  static Future addLoginStatusListener() async{
//
//    _eventChannel.receiveBroadcastStream().listen((data){
//
//      //用同一个通道，针对不同的data做处理
//
//    });
//
//  }

  ///添加会话消息监听
  static addListener(ValueChanged<List<NIMessage>> messageListener) async {
    Lsnetchatplugin.messageListener = messageListener;
    _channel.invokeMethod("messageListener");
  }

  ///移除监听
  static Future removeListener() async {
    messageListener = null;
    _channel.invokeMethod("removeMessageListener");
  }

  ///获取房间信息
  static Future<ChatRoomInfoData> getRoomInfo(String roomId) =>
      _channel.invokeMethod("roomInfo", {"roomId": roomId}).then((data) {
        return ChatRoomInfoData()
          ..code = data["code"]
          ..onlineUserCount = data["message"];
      });

  ///发送直播结束消息
  static void stopPlayer(String roomId) {
    _channel.invokeMethod("sendPlayerExitMessage", {"roomId": roomId});
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
