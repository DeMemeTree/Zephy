//
//  Assets.swift
//  Zephy
//
//
import Foundation

enum Assets: String {
    case zeph = "ZEPH"
    case zsd = "ZEPHUSD"
    case zrs = "ZEPHRSV"
    
    var uiDisplay: String {
        switch self {
        case .zeph: return "Zeph"
        case .zsd: return "ZSD"
        case .zrs: return "ZRS"
        }
    }
}
