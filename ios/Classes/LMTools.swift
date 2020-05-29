//
//  LMTools.swift
//  lsnetchatplugin
//
//  Created by yunxiwangluo on 2020/5/18.
//

import UIKit

class LMTools {
    
    //处理success返回给flutter
    //des:描述
    static func resultSuccessToFlutter(des: String)->Dictionary<String,Any>{
        
           return [
               "code": 0,
               "message": des
           ]
              
       }
    

    //处理error返回给flutter
    static func resultErrorToFlutter(error: Error)->Dictionary<String,Any>{
              
           let e: NSError = error as NSError
           
           let errorDes: String = e.userInfo["NSLocalizedDescription"] as? String ?? "";
           
           return [
                "code": e.code,
               "message": errorDes
           ]
              
       }
    
}
