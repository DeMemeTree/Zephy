//
//  TimeKeeper.swift
//  Zephy
//
//
import SwiftUI
import Combine

final class TimeKeeper: ObservableObject {
    var pulse = PassthroughSubject<(), Never>()
    
    private var timer = Timer.publish(every: 60, on: .main, in: .common)
    private var timerSubscription: Cancellable?
    private var notificationSubscriptions = Set<AnyCancellable>()
    
    static var isProtectedDataAvailable = CurrentValueSubject<Bool, Never>(false)

    init() {
        DispatchQueue.main.async {
            TimeKeeper.isProtectedDataAvailable.send(UIApplication.shared.isProtectedDataAvailable)
        }
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.startTimer()
            }
            .store(in: &notificationSubscriptions)

        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.stopTimer()
            }
            .store(in: &notificationSubscriptions)
        
        
        NotificationCenter.default.publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification)
           .sink { _ in
               TimeKeeper.isProtectedDataAvailable.send(false)
           }
           .store(in: &notificationSubscriptions)

       NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)
           .sink { _ in
               TimeKeeper.isProtectedDataAvailable.send(true)
           }
           .store(in: &notificationSubscriptions)
    }

    private func startTimer() {
        stopTimer()
        timerSubscription = timer.autoconnect().sink { [weak self] _ in
            self?.pulse.send()
        }
    }

    private func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
}
