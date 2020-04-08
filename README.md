## SearchGitHubUserApp
## 概要
GitHubのユーザーを検索し
ユーザーごとに詳細を閲覧できるシンプルなアプリ

## 目的
以下の理解と実装
- RxSwift * MVVMを用いた実装
- 汎用的なAPI通信部分を元に、個別API部分の追加

## 機能
- [ユーザー検索]キーワードを元に検索結果としてユーザー一覧をtableViewに表示する
- [ユーザーページの閲覧]WebViewを用い、セルをタップすることでユーザーの詳細を閲覧する

## 工夫した点
- 大型もしくは縦長のデバイスでも使いやすいよう、操作が親指の届きやすい画面下部のみで済むようにボタンを配置した。
- 時間内API制限による煩わしさを緩和するため、ページネーション型のUIにした。

## 利用ライブラリ
- Rx関連
  - RxSwift
  - RxCocoa
  - Unio

- 通信簡易化
  - Alamofire
  - SDWebImage
  
- UI
  - SVProgressHUD
  - R.swift
  - lottie-ios
  
- その他
  - SwiftLint

## 操作動画
![SearchGitHubApp](https://user-images.githubusercontent.com/17854586/78731215-0aa86300-797a-11ea-87ee-2b86f4d10c5e.gif)

## その他
課題実装前にSwift5.2にバージョンアップを試みたのですが、
詰まってしまったため(toolchain最新版を入れても、プルダウンに出てこないため)、SWIFT VERSION5.0で開発させていただきました。

よろしくお願いいたします。


