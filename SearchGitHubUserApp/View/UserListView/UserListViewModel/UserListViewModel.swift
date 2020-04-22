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
    
    struct State: StateType {
        let userListData = PublishRelay<[User]>()
        let userTotalCount = PublishRelay<Int?>()
        let errorMessage = PublishRelay<String?>()
        let pageNum = PublishRelay<Int?>()
    }
    
    struct Input: InputType {
        let searchKeyword = PublishRelay<String?>()
        let pageNum = PublishRelay<Int?>()
    }
    
    struct Output: OutputType {
        let userListData: PublishRelay<[User]>
        let userTotalCount: PublishRelay<Int?>
        let errorMessage: PublishRelay<String?>
        let pageNum: PublishRelay<Int?>
    }
    
    struct Extra: ExtraType {
        let userListUseCase: UserListUseCase
    }
    
    static func bind(from dependency: Dependency<UserListViewStream.Input, State, UserListViewStream.Extra>, disposeBag: DisposeBag) -> UserListViewStream.Output {
        let usecase = dependency.extra.userListUseCase
        let state = dependency.state
        
        Observable.combineLatest(dependency.inputObservable(for: \.pageNum), state.userTotalCount)
            .subscribe(onNext: { (page, userCount) in
                if page ?? 1 * AppConst.perPageNum <= userCount ?? 0 {
                    state.pageNum.accept(page)
                }
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(dependency.inputObservable(for: \.searchKeyword), dependency.inputObservable(for: \.pageNum)).subscribe(onNext: { (arg0) in
            let (_, _) = arg0
            fetchDataForOutput(usecase: usecase, state: state, disposeBag: disposeBag, key: arg0.0!, page: arg0.1!)
            }).disposed(by: disposeBag)
        
        return Output(userListData: state.userListData, userTotalCount: state.userTotalCount, errorMessage: state.errorMessage, pageNum: state.pageNum)
    }
}

extension UserListViewStream {
    static func fetchDataForOutput(usecase: UserListUseCase, state: UserListViewStream.State, disposeBag: DisposeBag, key: String, page: Int) {
        
        usecase.fetchData(searchKeyword: key, pageNum: page)
            .subscribe(onSuccess: { (response) in
                
                if let data = response.left {
                    state.userListData.accept(data.items ?? [])
                    state.userTotalCount.accept(data.totalCount)
                }
                if let error = response.right {
                    state.errorMessage.accept(error.message)
                }
            }, onError: { (error) in
                state.errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
