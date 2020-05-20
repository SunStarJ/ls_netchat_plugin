//
//  LMChatRoomManager.swift
//  lsnetchatplugin
//
//  Created by yunxiwangluo on 2020/5/13.
//

import UIKit
import NIMSDK

class LMChatRoomManager: NSObject {
    
    static let shareInstance = LMChatRoomManager();
    
    //加入聊天室
    func joinChatRoom(withRoomId roomid: String,nickName: String,result: @escaping FlutterResult){
        
        let request = NIMChatroomEnterRequest();
        request.roomId = roomid;
        request.roomNickname = nickName;
        
       enterChatRoom(withRequest: request, result: result)
        
    }
    
    func enterChatRoom(withRequest request: NIMChatroomEnterRequest,result: @escaping FlutterResult){
        //进入聊天室
        NIMSDK.shared().chatroomManager.enterChatroom(request) { (error, chatRoom, roomMember) in
            
            if let e = error{
                print("LM_进入聊天室出错:\(e)")
                
                result(LMTools.resultErrorToFlutter(error: e))
                
            }else{
                print("LM_进入聊天室成功:\(String(describing: chatRoom)),roomMember:\(String(describing: roomMember))")
                
                result(LMTools.resultSuccessToFlutter(des: "LM_进入聊天室成功"))
                
            }

        }
    }
    
    
    //退出聊天室
    func exitChatRoom(withRoomId roomid: String,result: @escaping FlutterResult){
        NIMSDK.shared().chatroomManager.exitChatroom(roomid) { (error) in
            if let e = error{
             
                print("退出聊天室出错：\(e)")
                
                result(LMTools.resultErrorToFlutter(error: e))
                
            }else{
                print("退出聊天室成功")
                
                result(LMTools.resultSuccessToFlutter(des: "退出聊天室成功"))
            }
        }
    }
    
    //获取聊天室信息
    func getChatRoomInfo(roomId: String, result:@escaping FlutterResult){
            
            NIMSDK.shared().chatroomManager.fetchChatroomInfo(roomId) { (error, chatRoom) in
                
                if let e = error{
                 
                    print("获取聊天室信息出错：\(e)")
                    
                    result(LMTools.resultErrorToFlutter(error: e))
                    
                }else{
                    print("获取聊天室信息成功")
                    
                    result([
                        "code": 0,
                        "message": chatRoom?.onlineUserCount ?? 0
                    ]
    )
                }
                
                
            }
            
        }
    
    //添加聊天室监听
    func addChatRoomManagerObsever(){
        NIMSDK.shared().chatroomManager.add(self);
    }
    
    //添加聊天室监听
    func removeChatRoomManagerObsever(){
        NIMSDK.shared().chatroomManager.remove(self);
    }
    
    //打印错误信息
    func LMLogError(des:String,error: Error?){
       if let e = error{
           print("LM_\(des):\(e)")
       }
    }
}

//聊天室监听回调
extension LMChatRoomManager: NIMChatroomManagerDelegate{
    
    //被踢回调
    func chatroomBeKicked(_ result: NIMChatroomBeKickedResult) {
        
        print("被踢了兄得，自己走吧")
        
        MessageListenerChannelSupport.sharedInstance.LoginStatusEventChannelToFlutter(des: "被踢了兄得，自己走吧")
    }
    
    //连接状态回调
    func chatroom(_ roomId: String, connectionStateChanged state: NIMChatroomConnectionState) {
        
        var des = "";
        
        switch state {
            case .entering:
                print("正在进入聊天室...")
                des = "正在进入聊天室...";
                break;
            case .enterOK:
                print("进入聊天室成功")
                des = "进入聊天室成功";
                break;
            case .enterFailed:
                print("进入聊天室失败")
                des = "进入聊天室失败";
                break;
            case .loseConnection:
                print("和聊天室断开")
                des = "和聊天室断开";
                break;
            default:
                break;
        }
        
        MessageListenerChannelSupport.sharedInstance.LoginStatusEventChannelToFlutter(des: des)
        
    }
    
    // 聊天室自动登录出错
    func chatroom(_ roomId: String, autoLoginFailed error: Error) {
        
    }
    
    

}
