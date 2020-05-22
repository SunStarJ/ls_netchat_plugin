# lsnetchatplugin

网易云聊天组件(目前只支持聊天室)

## 使用

**1.安装**
```
ls_netchat_plugin:
    git: https://github.com/SunStarJ/ls_netchat_plugin.git
```
**2.导入**
```
import 'package:lsnetchatplugin/lsnetchatplugin.dart';

```
**3.使用**
```
初始化
...
  //参数：appKey
  Lsnetchatplugin.initChatUtil("8d4f15775c9cb2a2a44fca0025e4c0a0");
...
```
**4.内部方法**
```
  //登录
  //传入参数：账号，token.(这俩参数都是后台服务器去网易云端创建)
  //回调类型：LSNetChatPluginMethodChannelResultData
  Lsnetchatplugin.login("账号", "token").then((data) {

   });


  //进入聊天室
  //传入参数：聊天室id,用户在聊天室使用的昵称
  //回调类型：LSNetChatPluginMethodChannelResultData
  Lsnetchatplugin.enterChatRoom("roomId", "nickName").then((data){

   });


   //退出聊天室
   //传入参数：聊天室id
   //回调类型：LSNetChatPluginMethodChannelResultData
   Lsnetchatplugin.exitChatRoom(_roomId).then((data){

    });

    //查询聊天室信息
    //传入参数：聊天室id
    //回调类型：ChatRoomInfoData
    Lsnetchatplugin.getRoomInfo(_roomId).then((data){

    });

    //发送文本消息
    //传入参数：要发送的内容,聊天室id,用户在聊天室使用的昵称
    //回调类型：LSNetChatPluginMethodChannelResultData
    Lsnetchatplugin.sendTextMessage(_controller.text,_roomId,"樱桃大丸子").then((data){

    });

    //退出登录
    //回调类型：LSNetChatPluginMethodChannelResultData
    Lsnetchatplugin.logout().then((data) {

    });

     //添加消息监听
     //回调类型：List<NIMessage>
     Lsnetchatplugin.addListener((messages){

     });

     //移除消息监听
     Lsnetchatplugin.removeListener();


```
