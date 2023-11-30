//
//  StatsView.swift
//  Zephy
//
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Stats")
                    .font(.body)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                
                HStack {
                    detailView(title: "Zeph Price",
                               value: "$27")
                    
                    detailView(title: "ZSD Rate",
                               value: "0.03 ZEPH")
                    
                    detailView(title: "ZRS Rate",
                               value: "1.01 ZEPH")
                }
                
                statCardView(title: "Zeph",
                             value: "844,918.81",
                             label: "Reserve")
                
                statCardView(title: "Zephyr Stable Dollars",
                             value: "1,146,900",
                             label: "Circulation")
                
                statCardView(title: "Zephyr Reserve Shares",
                             value: "627,949.07",
                             label: "Circulation")
            }
            
        }
//        HStack(spacing: 20) {
//            VStack {
//                statCardView(title: "Zeph", value: "244,918.81", label: "Reserve")
//                Spacer()
//                VStack {
//                    detailView(title: "Zeph Rate", value: "$2.27")
//                    detailView(title: "ZSD Rate", value: "0.44 ZEPH")
//                    detailView(title: "ZRS Rate", value: "0.64 ZEPH")
//                }
//            }
//
//            VStack {
//                statCardView(title: "Zephyr Stable Dollars", value: "76,900", label: "Circulation")
//                Spacer()
//                HStack {
//                    detailView(title: "Assets", value: "$555,550.41")
//                    detailView(title: "Liabilities", value: "$76,900")
//                    detailView(title: "Equity", value: "$478,650.41")
//                }
//            }
//
//            VStack {
//                statCardView(title: "Zephyr Reserve Shares", value: "327,949.07", label: "Circulation")
//                Spacer()
//                HStack {
//                    detailView(title: "Reserve Ratio", value: "722.43%")
//                }
//            }
//        }
    }
    
    func statCardView(title: String, value: String, label: String) -> some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(value)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
        .padding()
    }
    
    func detailView(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
                .foregroundColor(.white)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
