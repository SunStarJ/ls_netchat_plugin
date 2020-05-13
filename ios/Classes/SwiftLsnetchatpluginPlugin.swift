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
            LMChatRoomManager.shareInstance.joinChatRoom(withRoomId: dict?["roomId"] ?? "",result: result)
        break;
        case "exitChatRoom"://离开聊天室
            LMChatRoomManager.shareInstance.exitChatRoom(withRoomId: dict?["roomId"] ?? "",result: result)
        break;
        case "sendTextMessage"://发送文本消息
            NIMSDKManager.shareInstance.sendATextMessage(text: dict?["message"] ?? "", sessionId: "",result: result)
        break;
        case "roomInfo"://获取房间信息
            LMChatRoomManager.shareInstance.getChatRoomInfo(withRoomId: "") { (chatRoom) in
                result(chatRoom?.name)
            }
        break;
        default:
            result(FlutterMethodNotImplemented);
        break;
    }
    
    //result("iOS " + UIDevice.current.systemVersion)
  }
}
