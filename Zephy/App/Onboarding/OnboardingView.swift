//
//  OnboardingView.swift
//  Zephy
//
//
import AVKit
import SwiftUI

struct OnboardingView: View {
    enum ViewState {
        case landing
        case instructions
    }
    @EnvironmentObject var router: Router
    @State var state: ViewState = .landing

    var body: some View {
        ZStack {
            VStack {
                Image("zeph")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame( width: 100, height: 100)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            switch state {
            case .landing:
                OnboardingLanding(state: $state)
            case .instructions:
                OnbaordingInstructions(overallState: $state)
            }
        }
        .font(.system(size: 13))
        .background(Color.zephyPurp)
        .foregroundColor(.white)
    }
}
