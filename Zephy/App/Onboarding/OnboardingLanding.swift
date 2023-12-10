//
//  OnboardingLanding.swift
//  Zephy
//
//
import SwiftUI

struct OnboardingLanding: View {
    @Binding var state: OnboardingView.ViewState
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                bodyView(proxy)
            }
        }
    }
    
    func bodyView(_ proxy: GeometryProxy) -> some View {
        VStack {
            logoSection()
            
            Text("The TSwizzle superfan app is here to help you determine your fan ranking and have fun!")
            
            signIn(proxy)
            newUser(proxy)
        }
        .padding(.horizontal, 15)
    }
    
    func logoSection() -> some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
            
            Text("Welcome To TSwizzle")
                .font(.system(size: 19, weight: .bold))
        }
        .padding([.leading, .bottom], 5)
    }
    
    func signIn(_ proxy: GeometryProxy) -> some View {
        Button {
            //state = .signIn
        } label: {
            Text("EXISTING")
            .font(.system(size: 19, weight: .bold))
                .frame(width: proxy.size.width - 20, height: 45)
                .background(RoundedRectangle(cornerRadius: 40)
                    .stroke(.white, lineWidth: 1))
        }
        .padding(.top, 20)
    }
    
    func newUser(_ proxy: GeometryProxy) -> some View {
        Button {
            state = .instructions
        } label: {
            Text("NEW USER")
            .font(.system(size: 19, weight: .bold))
                .frame(width: proxy.size.width - 20, height: 45)
                .background(RoundedRectangle(cornerRadius: 40)
                    .stroke(.white, lineWidth: 1))
        }
        .padding(.top, 15)
        .padding(.bottom, 15)
    }
}
