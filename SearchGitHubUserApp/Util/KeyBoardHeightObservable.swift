//
//  KeyBoardHeightObservable.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/08.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import RxSwift
import RxCocoa

final class KeyBoardHeightObservable {
    static func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                            .map { notification -> CGFloat in
                                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                            },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                            .map { _ -> CGFloat in
                                0
                            }
            ])
            .merge()
    }
}
