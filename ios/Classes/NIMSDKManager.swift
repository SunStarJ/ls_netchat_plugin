//
//  NIMSDKManager.swift
//  lsnetchatplugin
//
//  Created by yunxiwangluo on 2020/5/9.
//

import UIKit
import NIMSDK

class NIMSDKManager: LMBaseFlutterManager{

    //let appKey = "0267466fd2eca06140a495685764048d";
    
    static let shareInstance = NIMSDKManager();
    
    //初始化sdk
    func initIM(appKey: String){
        //sdk配置
        let regisOption = NIMSDKOption(appKey: appKey)
        //1.sdk初始化
        NIMSDK.shared().register(with: regisOption)
        //打开输出
        NIMSDK.shared().enableConsoleLog();
        //添加监听
        addListener();
        
    }
    
    //添加监听
    func addListener(){
        
        NIMSDK.shared().loginManager.add(self);
        NIMSDK.shared().chatroomManager.add(self);
        self.addChatObsever();
        
    }
    
    
    func login(withAccount account: String,token: String,result: @escaping FlutterResult){
        
        //2.手动登录
        NIMSDK.shared().loginManager.login(account, token: token) { [weak self] (error) in
            
            if let e = error{
            
                self?.LMLogError(des: "手动登陆出错", error: e)
                
                result(LMTools.resultErrorToFlutter(error: e))
    
            }else{
                
                result(LMTools.resultSuccessToFlutter(des: NIMSDK.shared().loginManager.currentAccount()));
                
            }
        }
        //自动登录
        //NIMSDK.shared().loginManager.autoLogin("", token: "")
    }
    
    //登出IM
    func logoutIM(result: @escaping FlutterResult){
    
        NIMSDK.shared().loginManager.logout {[weak self] (error) in
            
            if let e = error{
                print("LM_登出失败:\(e)")
                
                result(LMTools.resultErrorToFlutter(error: e))
                
            }else{
                
                result(LMTools.resultSuccessToFlutter(des: "登出成功"))
                
                //退出登录后移除消息监听
                self?.addChatObsever()
            }
        }
    }
    
//    //进入聊天室
//    func enterChatRoom(roomId: String,nickName: String, result: @escaping FlutterResult){
//
//        let request = NIMChatroomEnterRequest()
//        request.roomId = roomId
//        request.roomNickname = nickName
//
//        enterChatRoom(withRequest: request, result: result)
//    }
//
//    //独立模式进入聊天室
//    func enterChatRoomIndependentMode(result: @escaping FlutterResult) {
//
//        let mode: NIMChatroomIndependentMode = NIMChatroomIndependentMode()
//        mode.token = "";
//        mode.username = ""
//
//        let request = NIMChatroomEnterRequest()
//        request.roomId = "110"
//        request.roomNickname = "面对疾风吧"
//        request.mode = mode
//
//        enterChatRoom(withRequest: request, result: result)
//
//    }
    
//    func enterChatRoom(withRequest request: NIMChatroomEnterRequest,result: @escaping FlutterResult){
//        //进入聊天室
//        NIMSDK.shared().chatroomManager.enterChatroom(request) { (error, chatRoom, roomMember) in
//
//            if let e = error{
//                print("LM_进入聊天室出错:\(e)")
//
//                result(LMTools.resultErrorToFlutter(error: e))
//
//            }else{
//                print("LM_进入聊天室成功:\(String(describing: chatRoom)),roomMember:\(String(describing: roomMember))")
//
//                result(LMTools.resultSuccessToFlutter(des: "LM_进入聊天室成功"))
//
//            }
//
//        }
//    }
    
    
    
//    //退出聊天室
//    func exitChatRoom(roomId: String, result: FlutterResult?){
//
//        //退出聊天室
//        NIMSDK.shared().chatroomManager.exitChatroom(roomId) { (error) in
//
//            if let e = error{
//
//                print("退出聊天室出错：\(e)")
//
//                result!(LMTools.resultErrorToFlutter(error: e))
//
//            }else{
//                print("退出聊天室成功")
//
//                result!(LMTools.resultSuccessToFlutter(des: "退出聊天室成功"))
//            }
//        }
//
//    }
    
//    func getChatRoomInfo(roomId: String, result:@escaping FlutterResult){
//
//        NIMSDK.shared().chatroomManager.fetchChatroomInfo(roomId) { (error, chatRoom) in
//
//            if let e = error{
//
//                print("获取聊天室信息出错：\(e)")
//
//                result(LMTools.resultErrorToFlutter(error: e))
//
//            }else{
//                print("获取聊天室信息成功")
//
//                result([
//                    "code": 0,
//                    "message": chatRoom?.onlineUserCount ?? 0
//                ]
//)
//            }
//
//
//        }
//
//    }
    
    
    
    //独立模式下聊天室注册ip地址
    func chatRoomIndependentModeregisterIP(address: String){
        
        NIMChatroomIndependentMode.registerRequestChatroomAddressesHandler { (roomId, callback) in
        
            callback(nil, [address])
            
        }
        
    }
    
    
    //添加消息监听
    func addChatObsever(){
        NIMSDK.shared().chatManager.add(self)
    }
    
    //移出消息监听
    func removeChatObsever(){
        NIMSDK.shared().chatManager.remove(self)
    }

    
    //一条自定义直播关闭消息
    func sendLiveEndMessage(sessionId: String,nicName: String,result: @escaping FlutterResult){
        
        let session = NIMSession(sessionId, type: NIMSessionType.chatroom);
        
        let endLiveMsg = NIMMessage();
        
        let customMsg = NIMCustomObject();
        customMsg.attachment = LMLiveEndAttachment()
        
        endLiveMsg.messageObject = customMsg;
        
        sendNIMMessage(message: endLiveMsg, session: session, result: result)
        
    }
    
    
    //发送一条文本消息
    func sendATextMessage(text: String,sessionId: String,nicName: String,result: @escaping FlutterResult){
        
       let session = NIMSession(sessionId, type: NIMSessionType.chatroom);
        let textMsg = NIMMessage();
        textMsg.text = text;
        textMsg.messageExt = nicName;
        
        sendNIMMessage(message: textMsg, session: session, result: result)
        
    }
    
    //
    func sendNIMMessage(message: NIMMessage,session: NIMSession,result: @escaping FlutterResult) {
        
        NIMSDK.shared().chatManager.send(message, to: session) { (error) in
            
//            if let e = error{
//                print("LM_发送文本消息:\(e)")
//                 result(LMTools.resultErrorToFlutter(error: e))
//
//            }else{
//                print("LM_发送文本消息成功")
//                result(LMTools.resultSuccessToFlutter(des: "发送文本消息成功"))
//            }
        }
        
    }
    
    
    func LMLogError(des:String,error: Error?){
        if let e = error{
            print("LM_\(des):\(e)")
        }
    }
}

//登录监听回调
extension NIMSDKManager: NIMLoginManagerDelegate{
    
    func onLogin(_ step: NIMLoginStep) {
        
        var des = "";
        
        switch step {
        case .linking:
            print("正在连接服务器...")
            des = "正在连接服务器..."
            break;
        case .linkOK:
            print("连接服务器成功")
            des = "连接服务器成功"
            break;
        case .linkFailed:
            print("连接服务器失败")
            des = "连接服务器失败"
            break;
        case .logining:
            print("登录中...")
            des = "登录中..."
            break;
        case .loginOK:
            print("登录成功")
            des = "登录成功"
            break;
        case .loginFailed:
            print("登录失败")
            des = "登录失败"
            break;
        case .loseConnection:
            print("网络连接断开")
            des = "网络连接断开"
            break;
        case .netChanged:
            print("网络状态切换")
            des = "网络状态切换"
            break;
        default:
            break;
        }
        
        
        MessageListenerChannelSupport.sharedInstance.LoginStatusEventChannelToFlutter(des: des)
        
    }
    
    //被踢了
    func onKick(_ code: NIMKickReason, clientType: NIMLoginClientType) {
        
        print("被踢了，兄得")
        
        
    }
    
    func onAutoLoginFailed(_ error: Error) {
        LMLogError(des: "自动登录", error: error)
    
        print("自动登录失败了，换个网吧兄得")
        
    }
    
}

//聊天消息监听回调
extension NIMSDKManager: NIMChatManagerDelegate{
    
    //收到消息回调
    func onRecvMessages(_ messages: [NIMMessage]) {
        MessageListenerChannelSupport.sharedInstance.sendMessageToFlutter(messages: messages)
        
    }
    
    func send(_ message: NIMMessage, didCompleteWithError error: Error?) {
        
        if let e = error{
            print("LM_发送文本消息:\(e)")
            MessageListenerChannelSupport.sharedInstance.messageSendResultEventChannelToFlutter(des: "LM_发送消息失败:\(e)");
            
        }else{
            
            MessageListenerChannelSupport.sharedInstance.messageSendResultEventChannelToFlutter(des: "LM_发送消息成功");
        }
        
        
    }
    
}

extension NIMSDKManager: NIMChatroomManagerDelegate{
    
    //自动登录出错
    //在重连时，可能遇到一些特殊网络错误（如聊天室用户被封禁，聊天室状态异常），会触发以下回调，开发者应该在这个回调中退出聊天室界面。
    func chatroom(_ roomId: String, autoLoginFailed error: Error) {
        
        print(error);
        
        
//        //退出房间
//        self.exitChatRoom(roomId: roomId, result: nil)
        
    }
    
}
