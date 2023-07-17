//
//  DebugPrintTool.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/8/31.
//

import UIKit

/// 打印log
func swiftDebug(_ items: Any..., fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG

    guard items.first != nil else {
        return
    }
    
    guard let file = fileName.components(separatedBy: "/").last else {
        return
    }
    
    // 获取当前时间
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale.current
    let convertedDate0 = dateFormatter.string(from: Date())
    
    print("Project: \(convertedDate0) \(file) \(methodName) line:\(lineNumber) \(items)")
    #endif
}
