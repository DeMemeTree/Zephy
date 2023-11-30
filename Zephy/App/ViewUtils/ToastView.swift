//
//  ToastView.swift
//  Zephy
//
//

import SwiftUI

struct Toast: View {
    let message: String
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(25)
            .shadow(radius: 10)
    }
}
