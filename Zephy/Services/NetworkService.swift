//
//  NetworkService.swift
//  Zephy
//
//
import Foundation

protocol NetworkServiceImpl {
    static func requestData(with request: URLRequest) async throws -> (Data, URLResponse)
}

final class NetworkService: NetworkServiceImpl {
    static func requestData(with request: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: request, delegate: nil)
    }
}
