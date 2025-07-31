//
//  UserResponseModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

struct UserResponseModel: Decodable {
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case login
    }
}
