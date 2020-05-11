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
    
    override init() {
        
        super.init();
        
        
        
        //sdk配置
        let regisOption = NIMSDKOption(appKey: appKey)
        //1.sdk初始化
        NIMSDK.shared().register(with: regisOption)
        
        //2.手动登录
        NIMSDK.shared().loginManager.login("", token: "") { [weak self] (error) in
         
            self?.LMLogError(des: "手动登陆", error: error)
            
        }
        
        //自动登录
        NIMSDK.shared().loginManager.autoLogin("", token: "")
        
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

extension NIMSDKManager: NIMLoginManagerDelegate{
    
    func onLogin(_ step: NIMLoginStep) {
        
    }
    
    func onAutoLoginFailed(_ error: Error) {
        
    }
    
}
