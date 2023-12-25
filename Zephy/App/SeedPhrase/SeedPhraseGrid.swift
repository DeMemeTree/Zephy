//
//  SeedPhraseGrid.swift
//  Zephy
//
//

import SwiftUI

struct SeedPhraseGrid: View {
    let seedPhrase: String
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        let words = seedPhrase.split(separator: " ").map(String.init)

        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<words.count, id: \.self) { index in
                    Text("\(index + 1). \(words[index])")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .onTapGesture {
                            if index + 1 == 25, UserDefaults.standard.bool(forKey: "xxx") {
                                UserDefaults.standard.setValue(true, forKey: "xx")
                            }
                        }
                }
            }
            .padding()
        }
    }
}
