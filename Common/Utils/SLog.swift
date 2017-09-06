//
//  SLog.swift
//  Common
//
//  Created by binea on 2017/3/9.
//  Copyright © 2017年 binea. All rights reserved.
//

import Foundation
import XCGLogger

public var SLog: XCGLogger.Type = XCGLogger.setup()

public extension XCGLogger {
    
    public class func setup() -> XCGLogger.Type {
        let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        
        let fileDestination = FileDestination(writeToFile: "\(NSTemporaryDirectory())/logs/XCGLogger.log", identifier: "advancedLogger.fileDestination")
        
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        
        // Optionally set some configuration options
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        
        
        
        // Create a file log destination
        
        
        // Optionally set some configuration options
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue
        
        // Add the destination to the logger
        log.add(destination: fileDestination)
        #if DEBUG
            // Add the destination to the logger
            log.add(destination: systemDestination)
            info(fileDestination.writeToFileURL)
            fileDestination.outputLevel = .debug
        #else
            fileDestination.outputLevel = .info
        #endif
        
        
        return self
    }
}
