//
//  OnboardingInstructions.swift
//  Zephy
//
//

import SwiftUI

struct OnbaordingInstructions: View {
    enum ViewState {
        case one
        case two
        case letsGo
    }
    @Binding var overallState: OnboardingView.ViewState
    @State var state: ViewState = .one
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                headerView()
                Spacer()
                bodyView(proxy)
            }
            .padding([.leading, .trailing], 10)
        }
        .contentShape(Rectangle())
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width < 0 {
                    // left
                    switch state {
                    case .one:
                        state = .two
                    case .two:
                        state = .letsGo
                    case .letsGo:
                        // TODO: Need to navigate on the router to home view
                        break
                    }
                }
                
                if value.translation.width > 0 {
                    // right
                    switch state {
                    case .one:
                        overallState = .landing
                    case .two:
                        state = .one
                    case .letsGo:
                        state = .two
                    }
                }
            }))
    }
    
    func headerView() -> some View {
        HStack {
            Spacer()
            
            Button {
                navigateToNext()
            } label: {
                Text("Skip")
                    .opacity(0.35)
            }
        }
        .padding(.trailing, 15)
        .font(.system(size: 13, weight: .bold))
    }
    
    func bodyView(_ proxy: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            switch state {
            case .one:
                firstView(proxy)
            case .two:
                secondView(proxy)
            case .letsGo:
                letsGoView(proxy)
            }
        }
    }
    
    func firstView(_ proxy: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text("Within this app you have an allocated amount of energy that you can use per day. - use it wisely")
                .font(.system(size: 26, weight: .bold))
                .padding(.bottom, 10)
            
            Text("You will be able to choose from quizes that have a dynamic amount of reward but also energy useage")
            
            rectangleView(proxy)
        }
    }
    
    func secondView(_ proxy: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text("We are going to help determine who is the #1 superfan through our leaderboard ranking system")
                .font(.system(size: 26, weight: .bold))
                .padding(.bottom, 10)
            
            Text("Plus we hope to make it a lot of FUN!")
            
            rectangleView(proxy)
        }
    }
    
    func letsGoView(_ proxy: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text("Sign up now!")
                .font(.system(size: 26, weight: .bold))
                .padding(.bottom, 10)
            
            Button {
                navigateToNext()
            } label: {
                Text("Let's go")
                    .font(.system(size: 19, weight: .bold))
                    .frame(width: proxy.size.width - 20, height: 45)
                    .background(RoundedRectangle(cornerRadius: 40)
                        .stroke(.white, lineWidth: 1))
            }
            .padding(.bottom, 50)
        }
    }
    
    func rectangleView(_ proxy: GeometryProxy) -> some View {
        VStack {
            HStack {
                Spacer()
                Rectangle()
                    //.foregroundColor(.groveGreen)
                    .frame(width: 0.1 * proxy.size.width, height: 4)
                
                if state == .two {
                    Rectangle()
                        //.foregroundColor(.groveGreen)
                        .frame(width: 0.1 * proxy.size.width, height: 4)
                } else {
                    Rectangle()
                        .foregroundColor(.white)
                        .opacity(0.1)
                        .frame(width: 0.1 * proxy.size.width, height: 4)
                }
                
                Rectangle()
                    .foregroundColor(.white)
                    .opacity(0.1)
                    .frame(width: 0.1 * proxy.size.width, height: 4)
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("swipe")
                    .font(.system(size: 10))
                    .opacity(0.35)
                Spacer()
            }
        }
        .padding(.top, 50)
    }
    
    private func navigateToNext() {
        overallState = .loadSeed
    }
}
