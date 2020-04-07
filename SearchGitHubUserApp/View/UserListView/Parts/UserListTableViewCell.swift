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
    func configure(data: User, rowHeight: CGFloat) {
        
        setConstraint(rowHeight: rowHeight)
        
        self.userNameLabel.text = data.loginID
        self.userTypeLabel.text = data.userType
        if data.avatarUrl != nil {
            self.avatarImageView.sd_setImage(with: URL(string: data.avatarUrl!), placeholderImage: R.image.placeholder())
        }
        self.userUrl = data.url
    }
}

extension UserListTableViewCell {
    func setConstraint(rowHeight: CGFloat) {
        //avatarImageViewのconstraint設定
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        self.avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: rowHeight * 0.1).isActive = true
        self.avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: rowHeight * 0.1).isActive = true
        self.avatarImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        self.avatarImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        
        //avatarImageViewの外観調整
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height * 0.1
        //userNameLabelのconstraint設定
        self.userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: rowHeight * -0.1).isActive = true
        self.userNameLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: rowHeight * 0.1).isActive = true
        self.userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: rowHeight * -0.1).isActive = true
        
        //userTypeLabelのconstraint設定
        self.userTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userTypeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: rowHeight * 0.1).isActive = true
        self.userTypeLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: rowHeight * 0.1).isActive = true
        self.userTypeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: rowHeight * -0.1).isActive = true
    }
}
