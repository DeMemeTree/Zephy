//
//  UInt+zephy.swift
//  Zephy
//
//

import Foundation

extension UInt64 {
    func formatHuman() -> String {
        return String(Double(self) / 1_000_000_000_000)
    }
}
