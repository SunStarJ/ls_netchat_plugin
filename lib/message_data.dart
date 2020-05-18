/**
 *
 * @ProjectName:    ls_netchat_plugin
 * @ClassName:      message_data
 * @Description:    消息类
 * @Author:         孙浩
 * @QQ:             243280864
 * @CreateDate:     2020/5/18 14:42
 */

class BaseMessage{
  int type;
  String nicName;
  TextMessageData textMessage;
}

class TextMessageData{
  String messageInfo;
}