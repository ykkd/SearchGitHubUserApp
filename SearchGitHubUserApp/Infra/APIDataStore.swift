//
//  APIDataStore.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol APIType {
    var urlString: String { get }
    var method: HTTPMethod { get }
    var parameters: APIRequestParameters? { get }
}

protocol APIRequestParameters: Encodable {
    func dict(snakeCase: Bool) -> [String: Any]
}

extension APIRequestParameters {
    func dict(snakeCase: Bool) -> [String: Any] {
        guard let jsonEncodedData = try? JSONHelper.encode(value: self, shouldConvertSnake: snakeCase),
        let dict = try? JSONSerialization
            .jsonObject(with: jsonEncodedData, options: []) as? [String: Any] else {
                return [:]
        }
        return dict
    }
}

protocol APIDataStore {
    func request(apiType: APIType) -> Single<Data>
}

final class APIDataStoreImpl {
    static let sharedManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Session(configuration: configuration)
    }()
}

extension APIDataStoreImpl: APIDataStore {
    func request(apiType: APIType) -> Single<Data> {
        return Single.create { observer in
            let params = apiType.parameters?.dict(snakeCase: true) ?? [:]
            APIDataStoreImpl.sharedManager.request(apiType.urlString, method: apiType.method, parameters: params)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        observer(.success(data))
                    case .failure(let error):
                        observer(.error(error))
                    }
                }
            return Disposables.create()
        }
    }
}
