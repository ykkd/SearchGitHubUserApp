//
//  Either.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/08.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

enum Either<Left, Right>{
    case left(Left)
    case right(Right)
    
    var left:Left? {
        switch self {
        case let .left(x):
            return x
            
        case .right:
            return nil
        }
    }
    
    var right:Right? {
        switch self {
        case .left:
            return nil
        case let .right(x):
            return x
        }
    }
}
