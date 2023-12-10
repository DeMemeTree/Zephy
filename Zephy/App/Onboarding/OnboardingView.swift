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
        case loadSeed
    }
    @EnvironmentObject var router: Router
    @State var state: ViewState = .landing
    var player = AVPlayer(url: Bundle.main.url(forResource: "onboarding", withExtension: "mp4")!)
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .disabled(true)
                    .overlay(
                        Rectangle()
                             .foregroundColor(.black)
                             .opacity(0.8)
                             .mask(LinearGradient(gradient: Gradient(colors: [
                                .black, .black, .clear, .clear, .clear ,
                             ]), startPoint: .bottom, endPoint: .top))
                                .ignoresSafeArea()
                    )
                
                switch state {
                case .landing:
                    OnboardingLanding(state: $state)
                case .instructions:
                    OnbaordingInstructions(overallState: $state)
                case .loadSeed:
                    EmptyView()
                        .onAppear {
                            router.changeRoot(to: .seedPhrase)
                        }
                }
            }
            .font(.system(size: 13))
            .background(Color.black)
            .foregroundColor(.white)
            .onAppear {
                player.play()
                addObserver()
            }
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                               object: nil,
                                               queue: nil) { _ in
            player.play()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                               object: nil,
                                               queue: nil) { _ in
            player.pause()
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: nil) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
}
