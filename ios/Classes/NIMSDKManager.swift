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
    
    override init() {
        super.init();
        
    }
    
    func login(withAccount account: String,token: String,result: @escaping FlutterResult){
        
        //2.手动登录
        NIMSDK.shared().loginManager.login(account, token: token) { [weak self] (error) in
            self?.LMLogError(des: "手动登陆", error: error)
            //登陆成功后添加消息监听
            self?.addChatObsever()
        }
        //自动登录
        //NIMSDK.shared().loginManager.autoLogin("", token: "")
    }
    
    //登出IM
    func logoutIM(result: @escaping FlutterResult){
    
        NIMSDK.shared().loginManager.logout {[weak self] (error) in
            
            if let e = error{
                print("LM_登出:\(e)")
            }
            //退出登录后移除消息监听
            self?.addChatObsever()
            
        }
    }
    
    
    //初始化sdk
    func initIM(appKey: String){
        //sdk配置
        let regisOption = NIMSDKOption(appKey: appKey)
        //1.sdk初始化
        NIMSDK.shared().register(with: regisOption)
        
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
    func sendATextMessage(text: String,sessionId: String,result: @escaping FlutterResult){
        
       let session = NIMSession(sessionId, type: NIMSessionType.chatroom);
        let textMsg = NIMMessage();
        textMsg.text = text;
        
        NIMSDK.shared().chatManager.send(textMsg, to: session) { (error) in
            
            if let e = error{
                print("LM_发送文本消息:\(e)")
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
    
    func onAutoLoginFailed(_ error: Error) {
        LMLogError(des: "自动登录", error: error)
    }
    
}

//聊天消息监听回调
extension NIMSDKManager: NIMChatManagerDelegate{
    
    //收到消息回调
    func onRecvMessages(_ messages: [NIMMessage]) {
        MessageListenerChannelSupport.sharedInstance.eventChannelToFlutter(messages: messages)
    }
    
}

