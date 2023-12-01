//
//  Subscriber+zephy.swift
//  Zephy
//
//
import Foundation
import Combine

extension AnyPublisher {
    func backgroundToMain() -> Self {
        return self
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
