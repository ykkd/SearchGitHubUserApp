//
//  APITypes+UserList.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation
import Alamofire

extension APITypes {
    enum UserList: APIType {
        
        case get(params: UserListParams)
        
        var urlString: String {
            switch  self {
            case .get:
                return APITypes.baseUrl
            }
        }
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            }
        }
        
        var parameters: APIRequestParameters? {
            switch self {
            case .get(let params):
                return params
            }
        }
    }
}
