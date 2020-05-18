/**
 *
 * @ProjectName:    ls_netchat_plugin
 * @ClassName:      message_data
 * @Description:    消息类
 * @Author:         孙浩
 * @QQ:             243280864
 * @CreateDate:     2020/5/18 14:42
 */

class MsgListResult {
  List<NIMessage> msgList;

  List<NIMessage> getResultFromMap(data) {
    msgList = List();
    data.forEach((info) {
      msgList.add(NIMessage()
        ..nicName = info["nicName"]
        ..msgType = info["msgType"]
        ..content = info["content"]);
    });

    return msgList;
  }
}

class NIMessage {
  int msgType;
  String nicName;
  String content;
//TextMessageData textMessage;
}

//class TextMessageData{
//  String messageInfo;
//}
