//
//  UserListViewController.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: UserListViewStream = UserListViewStream()
    let searchBar = UISearchBar(frame: .zero)
    let data: [User]? = []
    var rowHeight: CGFloat = 136
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        setTableView()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as! UserListTableViewCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
