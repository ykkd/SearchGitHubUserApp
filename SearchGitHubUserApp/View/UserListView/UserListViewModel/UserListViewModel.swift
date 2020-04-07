//
//  UserListViewModel.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation
import Unio
import RxSwift
import RxRelay

protocol UserListViewStreamType: AnyObject {
    var input: InputWrapper<UserListViewStream.Input> { get }
    var output: OutputWrapper<UserListViewStream.Output> { get }
}

final class UserListViewStream: UnioStream<UserListViewStream>, UserListViewStreamType {

    convenience init() {
        self.init(input: Input(), state: State(), extra: Extra(userListUseCase: UserListUseCaseProvider.provide()))
    }
    
    struct State:StateType {
        let userListData = PublishRelay<[User]>()
        let userTotalCount = PublishRelay<String?>()
        let errorMessage = PublishRelay<String?>()
    }
    
    struct Input: InputType {
        let searchKeyword = PublishRelay<String?>()
    }
    
    struct Output: OutputType {
        let userListData: PublishRelay<[User]>
        let userTotalCount: PublishRelay<String?>
        let errorMessage: PublishRelay<String?>
    }
    
    struct Extra: ExtraType {
        let userListUseCase: UserListUseCase
    }
    
    static func bind(from dependency: Dependency<UserListViewStream.Input, State, UserListViewStream.Extra>, disposeBag: DisposeBag) -> UserListViewStream.Output {
        let usecase = dependency.extra.userListUseCase
        let state = dependency.state
        
        dependency.inputObservable(for: \.searchKeyword)
            .subscribe(onNext: { (response) in

            if response != nil {
                fetchDataForOutput(usecase: dependency.extra.userListUseCase, state: dependency.state, disposeBag: disposeBag, key: response!, page: 1)
            }

            }).disposed(by: disposeBag)
        
        return Output(userListData: state.userListData, userTotalCount: state.userTotalCount, errorMessage: state.errorMessage)
    }
}

extension UserListViewStream {
    static func fetchDataForOutput(usecase: UserListUseCase, state: UserListViewStream.State, disposeBag: DisposeBag, key: String, page: Int) {
        
        usecase.fetchData(searchKeyword: key, pageNum: page)
            .subscribe(onSuccess: { (response) in
            if response.items != nil {
                state.userListData.accept(response.items!)
            }
        
            let totalCountStr = String(response.totalCount)
            state.userTotalCount.accept(totalCountStr)
                
        }) { error in
            state.errorMessage.accept(error.localizedDescription)
            }
        .disposed(by: disposeBag)
    }
    
}
