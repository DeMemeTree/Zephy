//
//  OnboardingLanding.swift
//  Zephy
//
//
import SwiftUI

struct OnboardingLanding: View {
    @EnvironmentObject var router: Router
    @Binding var state: OnboardingView.ViewState
    
    var body: some View {
        VStack {
            Spacer()
            bodyView()
        }
    }
    
    func bodyView() -> some View {
        VStack {
            logoSection()
            
            Text("The untraceable over-collateralized stablecoin protocol mobile wallet")
            
            signIn()
            newUser()
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 40)
    }
    
    func logoSection() -> some View {
        VStack {
            Text("Welcome To Zephii")
                .font(.system(size: 19, weight: .bold))
        }
        .padding([.leading, .bottom], 5)
    }
    
    func signIn() -> some View {
        Button {
            router.changeRoot(to: .restoreSeed)
        } label: {
            Text("RESTORE WALLET")
            .font(.system(size: 19, weight: .bold))
            .frame(width: UIScreen.main.bounds.width - 20, height: 45)
                .background(RoundedRectangle(cornerRadius: 40)
                    .stroke(.white, lineWidth: 1))
        }
        .padding(.top, 20)
    }
    
    func newUser() -> some View {
        Button {
            state = .instructions
        } label: {
            Text("CREATE NEW WALLET")
            .font(.system(size: 19, weight: .bold))
                .frame(width: UIScreen.main.bounds.width - 20, height: 45)
                .background(RoundedRectangle(cornerRadius: 40)
                    .stroke(.white, lineWidth: 1))
        }
        .padding(.top, 15)
        .padding(.bottom, 15)
    }
}
