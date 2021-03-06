//
//  String+Extentions.swift
//  AnYou
//
//  Created by Leo on 2017/3/4.
//  Copyright © 2017年 binea. All rights reserved.
//

import Foundation

extension String {
    public func dropPrefixed(_ prefix: String) -> String {
        if hasPrefix(prefix) {
            return substring(from: prefix.endIndex)
        }
        return self
    }
    
    public mutating func dropPrefix(_ prefix: String) {
        self = dropPrefixed(prefix)
    }
    
    public func toDate(withFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
}
