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
    
    func setUserListVCConstraintAndDesign() {
        
        self.infoLabel.textColor = .white
        self.view.backgroundColor = AppConst.baseColor
        
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
        
        //animation
        self.view.addSubview(self.baseView)
        self.baseView.backgroundColor = .clear
        self.view.bringSubviewToFront(self.baseView)
        
        self.baseView.translatesAutoresizingMaskIntoConstraints = false
        self.baseView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.baseView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.baseView.widthAnchor.constraint(equalToConstant: screenSize.width * 0.6).isActive = true
        self.baseView.heightAnchor.constraint(equalToConstant: screenSize.width * 0.6).isActive = true
        
        animateLottie(baseView: self.baseView, animationView: self.animationView, animation: self.animation!, playSpeed: 1.0)
//        //leftButtonのcoonstraint設定
//        self.leftButton.translatesAutoresizingMaskIntoConstraints = false
//        self.leftButton.heightAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.leftButton.widthAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.leftButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.leftButton.bounds.size.width * -0.6).isActive = true
//        self.leftButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: self.leftButton.bounds.size.width * -0.5).isActive = true
//
//        //rightButtonのcoonstraint設定
//        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
//        self.rightButton.heightAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.rightButton.widthAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.rightButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.rightButton.bounds.size.width * 0.6).isActive = true
//        self.rightButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: self.rightButton.bounds.size.width * -0.5).isActive = true
//
//        //searchButtonのcoonstraint設定
//        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
//        self.searchButton.heightAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.searchButton.widthAnchor.constraint(equalToConstant: screenSize.height / 12).isActive = true
//        self.searchButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.searchButton.bounds.size.width * 2.2).isActive = true
//        self.searchButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: self.rightButton.bounds.size.width * -0.5).isActive = true
    }
}


extension UserListViewController {
    
    func animateLottie(baseView: UIView, animationView:AnimationView, animation:Animation, playSpeed:Float){
        if animationView.isAnimationPlaying == false {
            //bgAnimation
            animationView.bounds = CGRect(x:0,y:0,width:
                baseView.bounds.width,height:baseView.bounds.height)
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
