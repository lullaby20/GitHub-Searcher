//
//  Network.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 29.07.2025.
//

import Foundation
import Combine

protocol Networking {
    func execute<T>(_ requestProviding: RequestProviding) -> AnyPublisher<T, Error> where T: Decodable
}

final class Network: Networking {
    private let keychainSecureStorage: KeychainSecureStorage
    
    init(keychainSecureStorage: KeychainSecureStorage) {
        self.keychainSecureStorage = keychainSecureStorage
    }
    
    func execute<T>(_ requestProviding: RequestProviding) -> AnyPublisher<T, Error> where T: Decodable {
        var urlRequest = requestProviding.urlRequest
        
        if requestProviding.shouldAddAuthorization,
           let accessToken = keychainSecureStorage.getValue(for: .accessToken) {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        // MARK: It's safe to do like this because GitHub always use .iso8601 format
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                    
                    #if DEBUG
                    print("Body - \(urlRequest.httpBody?.prettyPrintedJSONString ?? "")")
                    print("Result - \(result)")
                    print("Data = \(String(describing: result.data.prettyPrintedJSONString))")
                    #endif
                    
                    throw URLError(.badServerResponse)
                }
                
                #if DEBUG
                print("URLRequest = \(urlRequest)")
                print("Body - \(urlRequest.httpBody?.prettyPrintedJSONString ?? "")")
                print("Result - \(result)")
                print("Data = \(String(describing: result.data.prettyPrintedJSONString))")
                #endif
                
                return result.data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
