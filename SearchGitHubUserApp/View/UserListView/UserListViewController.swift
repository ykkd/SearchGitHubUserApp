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

class UserListViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    private let viewModel: UserListViewStream = UserListViewStream()
    private let disposeBag = DisposeBag()
    
    private let searchBar = UISearchBar(frame: .zero)
    private var data: [User] = []
    private var maxPageNum: Int = 1
    private var currentPageNum: Int = 1
    private var rowHeight: CGFloat = 136
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setTableView()
        self.bind()
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
            }).disposed(by: disposeBag)
        
        leftButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let nextPageNum = -1 + (self?.currentPageNum ?? 1)
                self?.viewModel.input.accept(for: \.pageNum).onNext(nextPageNum)
            }).disposed(by: disposeBag)

        searchButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                
                if self?.searchBar.showsCancelButton == true {
                    self?.searchBar.setShowsCancelButton(false, animated: true)
                    self?.searchBar.resignFirstResponder()
                } else {
                    self?.searchBar.becomeFirstResponder()
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func bindInputForSearchBar() {
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                SVProgressHUD.show()
                
                self?.viewModel.input.accept(for: \.searchKeyword).onNext(self?.searchBar.text)
                self?.viewModel.input.accept(for: \.pageNum).onNext(self?.currentPageNum)
                
                self?.searchBar.resignFirstResponder()
                self?.searchBar.setShowsCancelButton(false, animated: true)
                
                SVProgressHUD.dismiss()
            }).disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.searchBar.setShowsCancelButton(true, animated: true)
            }).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
                self?.searchBar.setShowsCancelButton(false, animated: true)
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
                
                self.infoLabel.text = String(self.currentPageNum) + " / " + String(maxPageNum) + "ページ目 " + String(totalCount) + "件"
                
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
    private func setSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.placeholder = "検索してみてください"
    }
}

extension UserListViewController {
    private func showEmptyView() {
        self.infoLabel.text = ""
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setTableView() {
        tableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        rowHeight = screenSize.height / 8
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as! UserListTableViewCell
        cell.configure(data: data[indexPath.row])
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
}
