//
//  AssetLogo.swift
//  Zephy
//
//
import SwiftUI

struct AssetLogo: View {
    let assetLogo: String
    var body: some View {
        switch assetLogo {
        case Assets.zrs.uiDisplay,
            Assets.zrs.rawValue:
            Image("zrs")
                .resizable()
                .frame(width: 40, height: 40)
        case Assets.zsd.uiDisplay,
            Assets.zsd.rawValue:
            Image("zsd")
                .resizable()
                .frame(width: 40, height: 40)
        case Assets.zeph.uiDisplay,
            Assets.zeph.rawValue:
            Image("zeph")
                .resizable()
                .frame(width: 40, height: 40)
        default: EmptyView()
        }
    }
}
