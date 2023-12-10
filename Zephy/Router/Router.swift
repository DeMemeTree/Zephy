//
//  Router.swift
//  Zephy
//
//
import Combine
import SwiftUI

final class Router: ObservableObject {
    indirect enum Route: Equatable {
        case onboarding
        case splash
        case wallet
        case seedPhrase
        
        case swap
        case send
        case receive
        
        case settings
    }
    
    @Published var navigationStack: [Route] = [.splash]
    private let routerTime = 0.2
    
    var topView: Route {
        return navigationStack.last ?? .splash
    }
    
    func popToRoot() {
        guard let first = navigationStack.first else { return }
        withAnimation(.easeInOut(duration: routerTime)) {
            navigationStack = [first]
        }
    }
    
    func push(route: Route) {
        withAnimation(.easeInOut(duration: routerTime)) {
            navigationStack.append(route)
        }
    }
    
    func pop() {
        guard navigationStack.count > 1 else { return }
        withAnimation(.easeInOut(duration: routerTime)) {
            navigationStack = navigationStack.dropLast(1)
        }
    }
    
    func changeRoot(to: Route) {
        withAnimation(.easeInOut(duration: routerTime)) {
            navigationStack = [to]
        }
    }
}

