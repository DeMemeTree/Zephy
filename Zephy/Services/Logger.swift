//
//  Logger.swift
//  Zephy
//
//
import Foundation

struct Logger {
    static func log(error: Error) {
        print(error.localizedDescription)
    }
}
