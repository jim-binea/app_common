//
//  SecurityUtil.swift
//  Service
//
//  Created by binea on 2017/3/2.
//  Copyright © 2017年 binea. All rights reserved.
//

import Foundation
import CryptoSwift

public class SecurityUtil {
    let aes: AES
    public init(key: String, iv: String) {
        aes = try! AES(key: key, iv: iv, blockMode: BlockMode.CBC, padding: PKCS7())
//        aes = try! AES(key: "smkldospdosldaaa", iv: "0392039203920300", blockMode: BlockMode.CBC, padding: PKCS7())
//        aes = try! AES(key: "renrenting201617", iv: "0592059205920300", blockMode: BlockMode.CBC, padding: PKCS7())
    }
    
    public func encryptAES(planText: String) -> String? {
        guard let data = planText.data(using: .utf8) else {
            return nil
        }
        guard let encryptData = try? data.encrypt(cipher: aes) else {
            return nil
        }
        return encryptData.base64EncodedString()
    }
    
    public func decryptAES(cipherText: String) -> String? {
        return try? cipherText.decryptBase64ToString(cipher: aes)
    }
}
