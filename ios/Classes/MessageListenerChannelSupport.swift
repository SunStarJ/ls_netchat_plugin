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
            dict["content"] = item.text
            dict["nicName"] = item.senderName
            dict["msgType"] = item.messageType.rawValue
            dicts.append(dict)
        }
        
        self.eventSink?(self.createResult(type: .receiveMessage, data: dicts));
    }
    
    
    func LoginStatusEventChannelToFlutter(des: String){
        
        self.eventSink?(des);
    }
    
    func ChatRoomLinkEventChannelToFlutter(des: String){
        
        self.eventSink?(des);
    }
    
    func createResult(type:ResultType,data:Any)->Dictionary<String, Any>{
        
        return ["type":type.rawValue,"data":data]
        
    }
    
    
}



