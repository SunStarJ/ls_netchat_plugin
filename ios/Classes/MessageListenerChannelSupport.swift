//
//  MessageListenerChannelSupport.swift
//  lsnetchatplugin
//
//  Created by yunxiwangluo on 2020/5/12.
//

import UIKit
import NIMSDK

enum ResultType: Int {
    //错误
    case error = -1;
    //接收到消息
    case receiveMessage = 105;
//    //发送直播结束消息
//    case sendLiveEndMessage = 401;
    
    //String类型信息回传
    case stringType = 999;
}


class MessageListenerChannelSupport: NSObject,FlutterPlugin,FlutterStreamHandler{
    
    static let sharedInstance = MessageListenerChannelSupport()
    
    var eventSink: FlutterEventSink?
    
    static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterEventChannel(name: "lsnetchatplugin_e", binaryMessenger: registrar.messenger())
        
        channel.setStreamHandler(self.sharedInstance);
  
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events;
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
         return nil
    }
    
    func sendMessageToFlutter(messages: [NIMMessage]){
        
        var dicts = Array<[String:Any]>();
        
        for item in messages {
            
            var dict = [String:Any]()
            
            if(item.messageType == .text){
            
                dict["content"] = item.text
                dict["nicName"] = item.senderName
                dict["msgType"] = item.messageType.rawValue
                dicts.append(dict)
                
            }else if (item.messageType == .notification){
            //对通知类型的消息处理
                if let o = item.messageObject,o.isKind(of: NIMNotificationObject.self){
                    
                    let msgObjc = o as! NIMNotificationObject;
                    
                    //如果是聊天室的通知消息
                    if msgObjc.notificationType == .chatroom{
                        
                        let chatRoomNoticContent = msgObjc.content as! NIMChatroomNotificationContent
                        
                        let nickName = chatRoomNoticContent.source?.nick
                        let type = chatRoomNoticContent.eventType
                        var content = "";
                        
                        switch type {
                        case .enter:
                            content = "进入直播间"
                            break
                        case .exit:
                            content = "离开直播间"
                            break
                        default:
                            content = ""
                            break
                        }
                        
                        dict["nicName"] = nickName
                        dict["content"] = content
                        dict["msgType"] = item.messageType.rawValue
                        dicts.append(dict)
                        
                    }
                }
            }else if (item.messageType == .custom){
                
                
                
            }
        }
        
        self.eventSink?(self.createResult(type: .receiveMessage, data: dicts));
    }
    
    
    func LoginStatusEventChannelToFlutter(des: String){
        
        self.eventSink?(self.createResult(type: .stringType, data: des));
    }
    
    func ChatRoomLinkEventChannelToFlutter(des: String){
        
        self.eventSink?(self.createResult(type: .stringType, data: des));
    }
    
    func messageSendResultEventChannelToFlutter(des: String){
        
        self.eventSink?(self.createResult(type: .stringType, data: des));
    }
    
    
    func createResult(type:ResultType,data:Any)->Dictionary<String, Any>{
        
        return ["type":type.rawValue,"data":data]
        
    }
    
    
}



