//
//  JSONHelper.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation

final class JSONHelper {
    static func encode<T: Encodable>(value: T, shouldConvertSnake: Bool) throws -> Data {
        let encoder = JSONEncoder()
        if shouldConvertSnake {
            encoder.keyEncodingStrategy = .convertToSnakeCase
        }
        return try encoder.encode(value)
    }
    
    static func decode<T: Decodable>(data: Data, shouldConvertSnake: Bool) throws -> T {
        let decoder = JSONDecoder()
        
        if shouldConvertSnake {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        }
        return try decoder.decode(T.self, from: data)
    }
}
