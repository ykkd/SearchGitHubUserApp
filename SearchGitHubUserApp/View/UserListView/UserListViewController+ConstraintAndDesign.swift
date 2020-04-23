//
//  USerListViewController+Constraint.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/08.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation
import UIKit
import Lottie

extension UserListViewController {
    
    func setUserListVCConstraintAndDesign(infoLabel: UILabel, tableView: UITableView, baseView: UIView) {
        
        infoLabel.textColor = .systemPurple
        self.view.backgroundColor = AppConst.baseColor
        
        //infoLabelのconstraint設定
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: screenSize.height / 16).isActive = true
        
        infoLabel.numberOfLines = 1
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.baselineAdjustment = .alignCenters
        infoLabel.minimumScaleFactor = 0.3
        infoLabel.backgroundColor = .clear
        
        //tableViewのconstraint設定
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        //animation
        view.addSubview(baseView)
        baseView.backgroundColor = .clear
        view.bringSubviewToFront(baseView)
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        baseView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        baseView.widthAnchor.constraint(equalToConstant: screenSize.width * 0.6).isActive = true
        baseView.heightAnchor.constraint(equalToConstant: screenSize.width * 0.6).isActive = true
    }
}

extension UserListViewController {
    
    func animateLottie(baseView: UIView, animationView: AnimationView, animation: Animation, playSpeed: Float) {
        if animationView.isAnimationPlaying == false {

            animationView.bounds = CGRect(x: 0, y: 0, width: baseView.bounds.width, height: baseView.bounds.height)
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFill

            animationView.animationSpeed = 0.3

            animationView.loopMode = .loop
            animationView.play()
            baseView.addSubview(animationView)
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
            animationView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
            animationView.heightAnchor.constraint(equalTo: baseView.heightAnchor).isActive = true
            animationView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        }
    }
}
