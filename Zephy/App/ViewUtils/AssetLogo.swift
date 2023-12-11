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
        case Assets.zrs.uiDisplay:
            Image("zrs")
                .resizable()
                .frame(width: 40, height: 40)
        case Assets.zsd.uiDisplay:
            Image("zsd")
                .resizable()
                .frame(width: 40, height: 40)
        case Assets.zeph.uiDisplay:
            Image("zeph")
                .resizable()
                .frame(width: 40, height: 40)
        default: EmptyView()
        }
    }
}
