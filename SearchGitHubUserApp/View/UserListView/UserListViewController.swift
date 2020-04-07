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
    
    private let viewModel: UserListViewStream = UserListViewStream()
    private let disposeBag = DisposeBag()
    
    let searchBar = UISearchBar(frame: .zero)
    var data: [User] = []
    var rowHeight: CGFloat = 136
    
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
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                SVProgressHUD.show()
                self?.viewModel.input.accept(for: \.searchKeyword).onNext(self?.searchBar.text)
                self?.searchBar.endEditing(true)
                
                SVProgressHUD.dismiss()
            }).disposed(by: disposeBag)
        
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
    }
    
    private func bindOutput() {
        self.viewModel.output.userListData
            .bind(onNext: { [weak self] outputData in
               self?.data = outputData
               self?.tableView.reloadData()
           }).disposed(by: disposeBag)
    }
    
}

extension UserListViewController {
    private func setSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Input user name"
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setTableView() {
        tableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
