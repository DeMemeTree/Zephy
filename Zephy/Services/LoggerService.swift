//
//  LoggerService.swift
//  Zephy
//
//
import Foundation

struct LoggerService {
    static func log(error: Error) {
        print(error.localizedDescription)
    }
}
