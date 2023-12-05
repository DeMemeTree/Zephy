//
//  NodeService.swift
//  Zephy
//
//
import Foundation

struct NodeService {
    struct Node: Decodable {
        let name: String
        let url: String
        let port: Int
        let height: Int
        let connectionsIn: Int
        let connectionsOut: Int
        let status: String
    }
    
    private static var nodesCache = NSCache<NSString, NSArray>()
    private static let cacheKey = "nodesCache"
    
    static var currentNode: String? {
        return nil
    }
    
    static var isNodeConnected: Bool {
        return false
    }
    
    static func fetchNodes() async throws -> [Node] {
        if let cachedNodes = nodesCache.object(forKey: cacheKey as NSString) as? [Node] {
            return cachedNodes
        }

        let url = URL(string: "https://zeph.network/api/nodes")!
        let request = URLRequest(url: url)

        let (data, _) = try await NetworkService.requestData(with: request)
        let nodes = try JSONDecoder().decode([Node].self, from: data)

        nodesCache.setObject(nodes as NSArray, forKey: cacheKey as NSString)

        return nodes
    }
}
