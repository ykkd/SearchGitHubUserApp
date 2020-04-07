//
//  User.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    let totalCount: Int
    let items: [User]?
    
    private enum SearchResponseKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchResponseKeys.self)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
        self.items = try? container.decode([User].self, forKey: .items)
    }
    
    init(count: Int, items: [User]?) {
        self.totalCount = count
        self.items = items
    }
    
    static func parse(_ data: Data) -> Either<SearchResponse,APILimit> {
        do {
            let response = try JSONDecoder().decode(SearchResponse.self, from: data)
            return .left(response)
        } catch {
//            print(String(data: data, encoding: .utf8))
            return .right(APILimit(message: "API Limt Over. 1分間あたりのAPI利用制限を超過しました。しばらくお待ちください。"))
        }
    }
}

struct User: Decodable {
    let loginID: String
    let avatarUrl: String?
    let url: String?
    let userType: String?
    
    private enum UserKeys: String, CodingKey {
        case loginID = "login"
        case avatarUrl = "avatar_url"
        case url = "html_url"
        case userType = "type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        self.loginID = try container.decode(String.self, forKey: .loginID)
        self.avatarUrl = try? container.decode(String.self, forKey: .avatarUrl)
        self.url = try? container.decode(String.self, forKey: .url)
        self.userType = try? container.decode(String.self, forKey: .userType)
    }
}
