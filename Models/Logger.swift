//
//  Logger.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/28/24.
//

import Foundation




class logManager: NSObject {
    
    var userLogLevel = logLevel.debug
    
    enum logLevel {
        case debug
        case info
        case warning
    }
    
    static let shared = logManager()
    func logMessage(_ userMessage: String,_ level: logLevel = .info){

        if userLogLevel == .debug {
            switch level {
            case .debug:
                print("⚙️ Debug:\(userMessage)")
            case .info:
                print("ℹ️ Info: \(userMessage)")
            case .warning:
                print("⚠️ Warning: \(userMessage)")
            }
        }
        
        if userLogLevel == .info {
            switch level {
            case .info:
                print("ℹ️ Info: \(userMessage)")
            case .warning:
                print("⚠️ Warning: \(userMessage)")
            default: return
            }
        }
        
        if userLogLevel == .warning {
            switch level {
            case .warning:
                print("⚠️ Warning: \(userMessage)")
            default: return
            }
        }
    }
    
}//singleton
