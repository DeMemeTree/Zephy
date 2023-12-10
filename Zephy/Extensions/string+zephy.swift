//
//  string+zephy.swift
//  Zephy
//
//

import Foundation

extension String {
    func humanToZeph() -> UInt64? {
        guard let zephAmount = Double(self) else {
            return nil
        }

        let picoPerZeph = 1_000_000_000_000
        let picoAmount = zephAmount * Double(picoPerZeph)
        return UInt64(picoAmount)
    }
}
