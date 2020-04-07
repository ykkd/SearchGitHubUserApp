//
//  USerListViewController+Constraint.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/08.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation
import UIKit

extension UserListViewController {
    
    func setUserListVCConstraint() {
        //infoLabelのconstraint設定
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.infoLabel.heightAnchor.constraint(equalToConstant: screenSize.height / 16).isActive = true
        
        self.infoLabel.numberOfLines = 1
        self.infoLabel.adjustsFontSizeToFitWidth = true
        self.infoLabel.baselineAdjustment = .alignCenters
        self.infoLabel.minimumScaleFactor = 0.3
        self.infoLabel.backgroundColor = .clear
        
        //tableViewのconstraint設定
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.infoLabel.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
//        //leftButtonのcoonstraint設定
//        self.leftButton.translatesAutoresizingMaskIntoConstraints = false
//        self.leftButton.heightAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.leftButton.widthAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.leftButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.leftButton.frame.size.width * -0.6).isActive = true
//        self.leftButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: self.leftButton.frame.size.width * -0.5).isActive = true
//
//        //rightButtonのcoonstraint設定
//        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
//        self.rightButton.heightAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.rightButton.widthAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.rightButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.rightButton.frame.size.width * 0.6).isActive = true
//        self.rightButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: self.rightButton.frame.size.width * -0.5).isActive = true
//
//        //searchButtonのcoonstraint設定
//        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
//        self.searchButton.heightAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.searchButton.widthAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.searchButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.searchButton.frame.size.width * 2.2).isActive = true
//        self.searchButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: self.rightButton.frame.size.width * -0.5).isActive = true
    }
}
