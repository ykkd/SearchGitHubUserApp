//
//  UserListTableViewCell.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    var userUrl: String?
}

extension UserListTableViewCell {
    func configure(data: User) {
        self.userNameLabel.text = data.loginID
        self.userTypeLabel.text = data.userType
        if data.avatarUrl != nil {
            UIImage.imageForHeadline(url: data.avatarUrl!, completion: { (image) in
                    self.avatarImageView.image = image
                })
        }
        self.userUrl = data.url
    }
}
