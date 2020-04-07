//
//  SearchGitHubUserAppTests.swift
//  SearchGitHubUserAppTests
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//
import XCTest
@testable import SearchGitHubUserApp

class SearchGitHubUserAppTests: XCTestCase {

    func test_UserSearchResponse() {
        guard let jsonObject = createDataObject() else {
            XCTFail("Dataの生成に失敗")
            return
        }
            let decoder = JSONDecoder()
        guard let task = try? decoder.decode(SearchResponse.self, from: jsonObject) else {
            XCTFail("SearchResponseの生成に失敗")
            return
        }
        XCTAssertEqual(task.totalCount, 7)
        XCTAssertEqual(task.items?[0].loginID, "mojombo")
        XCTAssertEqual(task.items?[0].avatarUrl, "https://avatars0.githubusercontent.com/u/1?v=4")
        XCTAssertEqual(task.items?[0].url, "https://github.com/mojombo")
        XCTAssertEqual(task.items?[0].userType, "User")
    }

    private func createDataObject() -> Data? {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.url(forResource: "response", withExtension: "json")
        let data = try! Data(contentsOf: path!, options: .uncached)
        return data
    }
}
