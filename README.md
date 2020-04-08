## SearchGitHubUserApp
## 概要
GitHubのユーザーを検索し
ユーザーごとに詳細を閲覧できるシンプルなアプリ

## 前提
- iOS11以上対応
- 対応機種：iPhone8、iPhoneSE、iPhone8Plus、iPhoneXS, iPhoneXS Max, iPhoneXR, iPad Air, iPad Pro
- 言語：swift5.0
- 画面向き：縦

## 目的
以下の理解と実装
- RxSwift * MVVMを用いた実装
- 汎用的なAPI通信部分を元に、個別API部分の追加

## 機能
- [ユーザー検索]キーワードを元に検索結果としてユーザー一覧をtableViewに表示する
- [ユーザーページの閲覧]任意のユーザを選択するとユーザ情報表示画面に遷移する

## 工夫した点
- 大型もしくは縦長のデバイスでも使いやすいよう、操作が親指の届きやすい画面下部のみで済むようにボタンを配置した。
- 時間内API制限による煩わしさを緩和するため、ページネーション型のUIにした。

## 利用ライブラリ（選定理由）
- Rx関連
  - RxSwift (RxSwiftでの実装のため)
  - RxCocoa (RxSwiftでの実装のため)
  - Unio (RxSwiftでの実装のサポート用)

- 通信簡易化
  - Alamofire (APIリクエスト通信の実装を簡易化するため)
  - SDWebImage (fetchした画像の表示簡便化するため)
  
- UI
  - SVProgressHUD (ローディングの表示を簡便化するため)
  - R.swift (各種リソースの表示を簡便化するため)
  - lottie-ios (アニメーションを簡単に実装するため)
  
- その他
  - SwiftLint (コーディングルールの統一のため)
※全てCocoaPodsを介して導入しています。<br>

## 操作動画
![SearchGitHubApp](https://user-images.githubusercontent.com/17854586/78731215-0aa86300-797a-11ea-87ee-2b86f4d10c5e.gif)

## その他
課題実装前にSwift5.2にバージョンアップを試みたのですが、
詰まってしまったため(toolchain最新版を入れても、プルダウンに出てこないため)、SWIFT VERSION5.0で開発させていただきました。


## PJ内容について補足
- 実装の大まかな流れは下記になります。
  - 1.API汎用通信部分作成
  - 2.今回利用するAPIに合わせた通信部分作成
  - 3.jsonデコードテスト
  - 4.UIの作成
  - 5.ViewModelの作成い
  - 6.データバインディングを行う
  - 7.レイアウトやデザインの調整
  - 8.細かな修正

- ブランチ運用の流れは下記になります。
  - 1.各機能の開発をfeature/XXX ブランチで行い
  - 2.developブランチにマージ
  - 3.ブランチ分けの必要がないと考えた修正はdevelopブランチにて実装
  - 4.アプリとして動く状態まで進んだタイミングでmasterブランチにマージ
  - 5.以後修正の必要があればまたdevelopに戻り、feature/XXXブランチを立てるか判断する
  
- 検索結果0件のときの表示: searchBar下のラベルに検索結果が０件の旨を表示しています
  
以上になります。
よろしくお願いいたします。


