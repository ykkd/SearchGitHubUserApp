//
//  UserListUseCase.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation
import RxSwift

protocol UserListUseCase {
    func fetchData(searchKeyword: String) -> Single<SearchResponse>
}

final class UserListUseCaseImpl: UserListUseCase {
    
    let apiDataStore: APIDataStore
    
    init(apiDataStore: APIDataStore) {
        self.apiDataStore = apiDataStore
    }
}

extension UserListUseCaseImpl {
    func fetchData(searchKeyword: String) -> Single<SearchResponse> {
        let params = UserListParams(q: searchKeyword)
        
        return apiDataStore.request(apiType: APITypes.UserList.get(params: params)).map {
            return SearchResponse.parse($0)
        }
    }
}

struct UserListParams: APIRequestParameters {
    let q: String
}

final class UserListUseCaseProvider {
    private init() {}
    
    static func provide() -> UserListUseCase {
        return UserListUseCaseImpl(apiDataStore: APIDataStoreImpl())
    }
}
