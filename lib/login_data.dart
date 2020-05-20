/**
 *
 * @ProjectName:    ls_netchat_plugin
 * @ClassName:      login_data
 * @Description:    登陆回传参数
 * @Author:         孙浩
 * @QQ:             243280864
 * @CreateDate:     2020/5/18 14:36
 */
class LoginData{
  int code;
  String message;
}

class ChatRoomInfoData{

  int code;
  int onlineUserCount;//在线人数（目前只想到用到这个，所以就传了这一个，以后再有再加）

}

class LSNetChatPluginMethodChannelResultData{

  int code;
  String message;

}