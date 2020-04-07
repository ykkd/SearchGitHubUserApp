//
//  UserListViewController.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import SafariServices
import Lottie

class UserListViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var leftButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!
    
    private let viewModel: UserListViewStream = UserListViewStream()
    private let disposeBag = DisposeBag()
    
    private let searchBar = UISearchBar(frame: .zero)
    private var data: [User] = []
    private var maxPageNum: Int = 1
    private var currentPageNum: Int = 1
    private var rowHeight: CGFloat = 136
    
    //lottieAnimation
    var baseView = UIView()
    let animationView = AnimationView()
    let animation = Animation.named(AppConst.octocatAnim)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        setUserListVCConstraintAndDesign()
        setInitialState()
        self.bind()
        
        SVProgressHUD.dismiss()
    }
}

extension UserListViewController {
    private func bind() {
        self.bindInput()
        self.bindOutput()
    }
    
    private func bindInput() {
        bindInputForSearchBar()
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                SVProgressHUD.show()
                let cell = self?.tableView.cellForRow(at: indexPath) as! UserListTableViewCell
                if let urlStr = cell.userUrl, let url = URL(string: urlStr) {
                    let safariViewController = SFSafariViewController(url: url)
                    self?.present(safariViewController, animated: true)
                }
                SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let nextPageNum = 1 + (self?.currentPageNum ?? 1)
                self?.viewModel.input.accept(for: \.pageNum).onNext(nextPageNum)
                self?.scrollToTop()
            }).disposed(by: disposeBag)
        
        leftButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let nextPageNum = -1 + (self?.currentPageNum ?? 1)
                self?.viewModel.input.accept(for: \.pageNum).onNext(nextPageNum)
                self?.scrollToTop()
            }).disposed(by: disposeBag)

        searchButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                if self?.searchBar.showsCancelButton == true {
                    
                    self?.searchBar.setShowsCancelButton(false, animated: true)
                    self?.searchBar.resignFirstResponder()
                    self?.searchButton.imageView?.image = R.image.search()
                    
                } else {
                    self?.searchBar.becomeFirstResponder()
                    self?.searchButton.imageView?.image = R.image.cancel()
                }
                
            }).disposed(by: disposeBag)
        
        keyboardHeight()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (keyboardHeight) in
                // adjust other views with keyboardHeight
                print(keyboardHeight)
                
                if keyboardHeight != 0 {
                    self?.leftButtonBottomConstraint.constant = keyboardHeight + AppConst.keyboardMargin
                    self?.rightButtonBottomConstraint.constant = keyboardHeight + AppConst.keyboardMargin
                    self?.searchButtonBottomConstraint.constant = keyboardHeight + AppConst.keyboardMargin
                } else {
                    self?.leftButtonBottomConstraint.constant = AppConst.defaultMargin
                    self?.rightButtonBottomConstraint.constant = AppConst.defaultMargin
                    self?.searchButtonBottomConstraint.constant = AppConst.defaultMargin
                }

            })
            .disposed(by: disposeBag)
    }
    
    private func bindInputForSearchBar() {
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                
                self?.baseView.isHidden = true
                
                SVProgressHUD.show()
                
                self?.viewModel.input.accept(for: \.searchKeyword).onNext(self?.searchBar.text)
                self?.viewModel.input.accept(for: \.pageNum).onNext(self?.currentPageNum)
                
                self?.searchBar.resignFirstResponder()
                self?.searchBar.setShowsCancelButton(false, animated: true)
                
                self?.searchButton.imageView?.image = R.image.search()
                
                SVProgressHUD.dismiss()
            }).disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.searchBar.setShowsCancelButton(true, animated: true)
                self?.searchButton.imageView?.image = R.image.cancel()
            }).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
                self?.searchBar.setShowsCancelButton(false, animated: true)
                self?.searchButton.imageView?.image = R.image.search()
            }).disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        self.viewModel.output.userListData
            .bind(onNext: { [weak self] outputData in
                
                SVProgressHUD.show()
                
                self?.data = outputData
                self?.tableView.reloadData()
                
                SVProgressHUD.dismiss()
                
           }).disposed(by: disposeBag)
        
        self.viewModel.output.userTotalCount
            .bind { response in
                let totalCount = response ?? 0
                
                var maxPageNum: Int = (totalCount / AppConst.perPageNum) + 1
                if totalCount <= AppConst.perPageNum {
                    maxPageNum = 1
                }
                
                if totalCount == 0 {
                    self.infoLabel.text = "検索結果は0件です"
                    self.leftButton.isHidden = true
                    self.rightButton.isHidden = true
                } else {
                    self.infoLabel.text = String(self.currentPageNum) + " / " + String(maxPageNum) + "ページ目"
                    self.leftButton.isHidden = false
                    self.rightButton.isHidden = false
                }
                
                if maxPageNum == self.currentPageNum {
                    self.rightButton.isHidden = true
                } else {
                    self.rightButton.isHidden = false
                }

                if self.currentPageNum == 1 {
                    self.leftButton.isHidden = true
                } else {
                    self.leftButton.isHidden = false
                }
                
            }.disposed(by: disposeBag)
        
        self.viewModel.output.errorMessage
            .bind(to: Binder(self) { me, message in
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                me.present(alert, animated: true, completion: nil)
                self.showEmptyView()
            }).disposed(by: disposeBag)
        
        self.viewModel.output.pageNum
            .bind(onNext: { [weak self] page in
                guard let page = page else { return }
                self?.currentPageNum = page
            }).disposed(by: disposeBag)
    }
    
}

extension UserListViewController {
    
    private func setInitialState() {
        
        rightButton.isHidden = true
        leftButton.isHidden = true
        
        setSearchBar()
        setTableView()
    }
    
    private func setSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.placeholder = "検索してみてください"
    }
    
    private func showEmptyView() {
        self.infoLabel.text = ""
    }
    
    private func setTableView() {
        tableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        rowHeight = screenSize.height / 8
        
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as! UserListTableViewCell
        cell.configure(data: data[indexPath.row], rowHeight: rowHeight)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserListTableViewCell
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func scrollToTop() {
        let topCellIndexPath: IndexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topCellIndexPath, at: .top, animated: false)
    }
}
