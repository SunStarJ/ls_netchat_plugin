import Flutter
import UIKit


public class SwiftLsnetchatpluginPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lsnetchatplugin", binaryMessenger: registrar.messenger())
    let instance = SwiftLsnetchatpluginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    //注册消息监听的channel
    MessageListenerChannelSupport.register(with: registrar)
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {    
    
    let dict = call.arguments as? [String:String]
    
    switch call.method {
        case "initChatUtil"://初始化聊天
            NIMSDKManager.shareInstance.initIM(appKey: dict?["appKey"] ?? "");
        break;
        case "login"://登录
            NIMSDKManager.shareInstance.login(withAccount: dict?["account"] ?? "", token: dict?["token"] ?? "",result: result)
        break;
        case "logout"://登出
            NIMSDKManager.shareInstance.logoutIM(result: result)
        break;
        case "enterChatRoom"://进入聊天室
                LMChatRoomManager.shareInstance.joinChatRoom(withRoomId: dict?["roomId"] ?? "", nickName: dict?["nicName"] ?? "",result: result)
        break;
        case "enterChatRoomWithOutLog":
            LMChatRoomManager.shareInstance.independentModeJoinChatRoom(withRoomId: dict?["roomId"] ?? "", getIPUrl: dict?["url"] ?? "", result: result)
        break
        case "exitChatRoom"://离开聊天室
            LMChatRoomManager.shareInstance.exitChatRoom(withRoomId: dict?["roomId"] ?? "",result: result)
        break;
        case "sendTextMessage"://发送文本消息
            NIMSDKManager.shareInstance.sendATextMessage(text: dict?["message"] ?? "", sessionId: dict?["roomId"] ?? "", nicName: dict?["nicName"] ?? "", result: result)
        break;
        case "roomInfo"://获取房间信息
            LMChatRoomManager.shareInstance.getChatRoomInfo(roomId: dict?["roomId"] ?? "", result: result);
        break;
        case "messageListener"://添加聊天消息监听
            NIMSDKManager.shareInstance.addChatObsever()
        break;
        case "removeMessageListener"://移除聊天消息监听
            NIMSDKManager.shareInstance.removeChatObsever()
        break;
        case "sendPlayerExitMessage":
            NIMSDKManager.shareInstance.sendLiveEndMessage(sessionId: dict?["roomId"] ?? "", nicName: "", result: result)
        break;
        default:
            result(FlutterMethodNotImplemented);
        break;
    }
    
    //result("iOS " + UIDevice.current.systemVersion)
  }
}
