//
//  TransactionView.swift
//  Zephy
//
//
import SwiftUI

struct TransactionView: View {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var transaction: WalletService.TransactionInfoRowSwift

    private var sourceColor: Color {
        guard let source_type = transaction.source_type else { return .gray }
        switch String(cString: source_type) {
        case Assets.zeph.rawValue:
            return .blue
        case Assets.zrs.rawValue:
            return .red
        case Assets.zsd.rawValue:
            return .green
        default:
            return .gray
        }
    }

    private var isPendingIndicator: String {
        return transaction.isPending != 0 ? "⏳" : "✅"
    }

    var body: some View {
        HStack(spacing: 0) {
            outInIndicator()
                .zIndex(2)
            contentView()
                .zIndex(1)
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
    
    func outInIndicator() -> some View {
        VStack {
            if let assetType = transaction.source_type {
                AssetLogo(assetLogo: String(cString: assetType))
                    .padding(5)
            }
            
            if transaction.direction == 1 {
                Text("OUT")
            } else {
                Text("IN")
            }
        }
        .font(.footnote)
        .frame(maxHeight: .infinity)
        .foregroundColor(.white)
        .background(Color.zephyPurp)
        .cornerRadius(10, corners: [.topLeft, .bottomLeft])
        .overlay(
            RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft])
                .stroke(transaction.direction == 1 ? .red : .green, lineWidth: 2)
        )
    }
    
    func contentView() -> some View {
        VStack {
            HStack {
                Text("Amount")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
                Text("\(transaction.amount.formatHuman())")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            HStack {
                Text("Fee")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
                Text("\(transaction.fee.formatHuman())")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            
            HStack {
                Text("Block")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
                Text("\(transaction.blockHeight)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            HStack {
                Text("Confirmations")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
                Text("\(transaction.confirmations)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            HStack {
                Text("\(Date(timeIntervalSince1970: TimeInterval(transaction.datetime)), formatter: dateFormatter)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
                Text(isPendingIndicator)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .cornerRadius(10, corners: [.topRight, .bottomRight])
        .overlay(
            RoundedCorner(radius: 10, corners: [.topRight, .bottomRight])
                .stroke(.gray.opacity(0.8), lineWidth: 2)
        )
    }
}
