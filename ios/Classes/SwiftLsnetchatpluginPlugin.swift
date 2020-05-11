import Flutter
import UIKit


public class SwiftLsnetchatpluginPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lsnetchatplugin", binaryMessenger: registrar.messenger())
    let instance = SwiftLsnetchatpluginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    
    
    print("Bundle.main.bundleIdentifier is \(Bundle.main.bundleIdentifier)")
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    let dict = call.arguments as? [String:String]
    
    switch call.method {
        case "initChatUtil":
            NIMSDKManager.shareInstance.initIM();
        break;
        case "login":
            NIMSDKManager.shareInstance.login(withAccount: dict?["account"] ?? "", token: dict?["token"] ?? "")
        break;
        case "enterChatRoom":
            NIMSDKManager.shareInstance.joinChatRoom(withRoomId: dict?["roomId"] ?? "")
        break;
        case "exitChatRoom":
            NIMSDKManager.shareInstance.exitChatRoom(withRoomId: dict?["roomId"] ?? "")
        break;
        case "sendTextMessage":
            NIMSDKManager.shareInstance.sendATextMessage(text: dict?["message"] ?? "", sessionId: "")
        break;
        case "messageListener":
            NIMSDKManager.shareInstance.addChatObsever()
        break;
        case "removeMessageListener":
            NIMSDKManager.shareInstance.removeChatObsever()
        break;
        case "roomInfo":
            NIMSDKManager.shareInstance.getChatRoomInfo(withRoomId: "") { (chatRoom) in
                
            }
        break;

    default:
        break;
    }
    
    
    
    result("iOS " + UIDevice.current.systemVersion)
  }
}
