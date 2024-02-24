//
//  ErrorPrinter.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 24.02.24.
//

import Foundation

final class ErrorPrinterService {
    static let shared = ErrorPrinterService()
    
    private init() {}
    
    func printToConsole(_ error: Error, file: String = #file, function: String = #function) {
        debugPrint("""
    >>>\(file), \
    \(function), \
    \(error.localizedDescription)
  """)
    }
}
