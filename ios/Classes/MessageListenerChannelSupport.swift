//
//  MessageListenerChannelSupport.swift
//  lsnetchatplugin
//
//  Created by yunxiwangluo on 2020/5/12.
//

import UIKit
import NIMSDK

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
    
    func eventChannelToFlutter(messages: [NIMMessage]){
        
        self.eventSink?(messages[0].text ?? "");
    }
    
    func LoginStatusEventChannelToFlutter(des: String){
        
        self.eventSink?(des);
    }
    
    func ChatRoomLinkEventChannelToFlutter(des: String){
        
        self.eventSink?(des);
    }
    
    
}



