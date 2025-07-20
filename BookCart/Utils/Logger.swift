//
//  Logger.swift
//  BookCart
//
//  Created by Khushboo Barve on 20/07/2025.
//

import Foundation

class Logger {
    static let shared = Logger()
    private let fileName = "app_log.txt"
    
    private init() {}
    
    private var logFileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(fileName)
    }
    
    func log(_ message: String, function: String = #function) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let fullMessage = "[\(timestamp)] [\(function)] \(message)\n"
        
        if let data = fullMessage.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logFileURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: logFileURL)
            }
        }
    }
    
    func readLog() -> String? {
        try? String(contentsOf: logFileURL)
    }
    
    func clearLog() {
        try? FileManager.default.removeItem(at: logFileURL)
    }
}
