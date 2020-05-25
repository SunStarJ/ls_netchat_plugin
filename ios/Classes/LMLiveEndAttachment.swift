//
//  LMLiveEndAttachment.swift
//  lsnetchatplugin
//
//  Created by yunxiwangluo on 2020/5/25.
//

import UIKit
import NIMAVChat

class LMLiveEndAttachment: NSObject,NIMCustomAttachment {
    
    func encode() -> String {
        return "401"
    }
    
}
