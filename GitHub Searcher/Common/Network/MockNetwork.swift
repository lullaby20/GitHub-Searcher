//
//  MockNetwork.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

final class MockNetwork: Networking {
    var result: ((any RequestProviding) -> AnyPublisher<Decodable, Error>)?
    
    func execute<T>(_ requestProviding: any RequestProviding) -> AnyPublisher<T, any Error> where T : Decodable {
        guard let result = result?(requestProviding) as? AnyPublisher<T, Error> else {
            return Fail(error: NSError(domain: "MockNetworkError", code: -1))
                .eraseToAnyPublisher()
        }
        
        return result
    }
}
