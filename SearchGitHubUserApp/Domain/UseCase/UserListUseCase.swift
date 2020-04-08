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
    func fetchData(searchKeyword: String, pageNum: Int) -> Single<Either<SearchResponse, APILimit>>
}

final class UserListUseCaseImpl: UserListUseCase {

    let apiDataStore: APIDataStore
    
    init(apiDataStore: APIDataStore) {
        self.apiDataStore = apiDataStore
    }
}

extension UserListUseCaseImpl {
    func fetchData(searchKeyword: String, pageNum: Int) -> Single<Either<SearchResponse, APILimit>> {
        let params = UserListParams(q: searchKeyword, page: pageNum, perPage: AppConst.perPageNum)
        return apiDataStore.request(apiType: APITypes.UserList.get(params: params)).map {
            return SearchResponse.parse($0)
        }
    }
}

struct UserListParams: APIRequestParameters {
    let q: String
    let page: Int
    let perPage: Int
}

final class UserListUseCaseProvider {
    private init() {}
    
    static func provide() -> UserListUseCase {
        return UserListUseCaseImpl(apiDataStore: APIDataStoreImpl())
    }
}

struct APILimit: Decodable {
    let message: String
}
