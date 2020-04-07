//
//  UserListTableViewCell.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import UIKit
import SDWebImage

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
            self.avatarImageView.sd_setImage(with: URL(string: data.avatarUrl!), placeholderImage: R.image.placeholder())
        }
        self.userUrl = data.url
    }
}
