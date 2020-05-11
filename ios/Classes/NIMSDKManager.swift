//
//  NIMSDKManager.swift
//  lsnetchatplugin
//
//  Created by yunxiwangluo on 2020/5/9.
//

import UIKit
import NIMSDK

class NIMSDKManager: NSObject{
    
    let appKey = "0267466fd2eca06140a495685764048d";
    
    static let shareInstance = NIMSDKManager();
    
    override init() {
        
        super.init();
        
        initIM();
        
    }
    
    func login(withAccount account: String,token: String){
        //2.手动登录
        NIMSDK.shared().loginManager.login(account, token: token) { [weak self] (error) in
            self?.LMLogError(des: "手动登陆", error: error)
        }
        
        //自动登录
        //NIMSDK.shared().loginManager.autoLogin("", token: "")
    }
    
    
    //初始化sdk
    func initIM(){
        //sdk配置
        let regisOption = NIMSDKOption(appKey: appKey)
        //1.sdk初始化
        NIMSDK.shared().register(with: regisOption)
    
        NIMSDK.shared().chatroomManager.add(self)
        
    
    }
    
    //加入聊天室
    func joinChatRoom(withRoomId roomid: String){
        
        //添加聊天室监听
        NIMSDK.shared().chatroomManager.add(self);
        
        
        let request = NIMChatroomEnterRequest();
        request.roomId = roomid;
        
        NIMSDK.shared().chatroomManager.enterChatroom(request) { (error, chatRoom, member) in
            
            print("进入聊天室：\(String(describing: error)),\(chatRoom),\(member)");
            
        }
        
    }
    
    //退出聊天室
    func exitChatRoom(withRoomId roomid: String){
        NIMSDK.shared().chatroomManager.exitChatroom(roomid) { (error) in
            self.LMLogError(des: "退出聊天室", error: error);
            
            //这里退出聊天室释放监听
            self.removeChatObsever()
            
        }
    }
    
    func getChatRoomInfo(withRoomId roomid: String){
        NIMSDK.shared().chatroomManager.fetchChatroomInfo(roomid) { (error, chatRoom) in
            
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

    
    //发送一条文本消息
    func sendATextMessage(text: String,sessionId: String){
        
       let session = NIMSession(sessionId, type: NIMSessionType.chatroom);
        let textMsg = NIMMessage();
        textMsg.text = text;
        
        NIMSDK.shared().chatManager.send(textMsg, to: session) { (error) in
            
            if let e = error{
                print("LM_发送文本消息:\(e)")
            }
            
        }
    }
    
    
    //登出IM
    func logoutIM(){
        
        NIMSDK.shared().loginManager.logout { (error) in
            
            if let e = error{
                print("LM_登出:\(e)")
            }
            
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
        
    }
    
    func onAutoLoginFailed(_ error: Error) {
        
    }
    
}

//聊天消息监听回调
extension NIMSDKManager: NIMChatManagerDelegate{
    
    //收到消息回调
    func onRecvMessages(_ messages: [NIMMessage]) {
        
    }
    
}

//聊天室监听回调
extension NIMSDKManager: NIMChatroomManagerDelegate{
    
    //被踢回调
    func chatroomBeKicked(_ result: NIMChatroomBeKickedResult) {
        
    }
    
    //连接状态回调
    func chatroom(_ roomId: String, connectionStateChanged state: NIMChatroomConnectionState) {
        
    }
    
    //自动登录出错回调
    func chatroom(_ roomId: String, autoLoginFailed error: Error) {
        
    }

}
