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
    func joinChatRoom(withRoomId roomid: String){
        
        let request = NIMChatroomEnterRequest();
        request.roomId = roomid;
        
        NIMSDK.shared().chatroomManager.enterChatroom(request) { (error, chatRoom, member) in
            self.addChatRoomManagerObsever();
            print("进入聊天室：\(String(describing: error)),\(String(describing: chatRoom)),\(String(describing: member))");
        }
        
    }
    
    //退出聊天室
    func exitChatRoom(withRoomId roomid: String){
        NIMSDK.shared().chatroomManager.exitChatroom(roomid) { (error) in
            self.LMLogError(des: "退出聊天室", error: error);
             self.removeChatRoomManagerObsever();
        }
    }
    //获取聊天室信息
    func getChatRoomInfo(withRoomId roomid: String,callBack:@escaping ((_ chatRoomInfo: NIMChatroom?)->Void)){
        NIMSDK.shared().chatroomManager.fetchChatroomInfo(roomid) { (error, chatRoom) in
            callBack(chatRoom)
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
        
    }
    
    //连接状态回调
    func chatroom(_ roomId: String, connectionStateChanged state: NIMChatroomConnectionState) {
        
        switch state {
            case .entering:
                print("正在进入聊天室...")
                break;
            case .enterOK:
                print("进入聊天室成功")
                break;
            case .enterFailed:
                print("进入聊天室失败")
                break;
            case .loseConnection:
                print("和聊天室断开")
                break;
            default:
                break;
        }
        
    }
    
    //自动登录出错回调
    func chatroom(_ roomId: String, autoLoginFailed error: Error) {
        
    }

}
