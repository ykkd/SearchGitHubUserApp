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

    }
    
    struct Input: InputType {

    }
    
    struct Output: OutputType {

    }
    
    struct Extra: ExtraType {
        let userListUseCase: UserListUseCase
    }
    
    static func bind(from dependency: Dependency<UserListViewStream.Input, State, UserListViewStream.Extra>, disposeBag: DisposeBag) -> UserListViewStream.Output {
        let usecase = dependency.extra.userListUseCase
        let state = dependency.state
        return Output()
    }
}
