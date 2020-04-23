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

    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    
    @IBOutlet private weak var leftButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchButtonBottomConstraint: NSLayoutConstraint!
    
    private let viewModel: UserListViewStream = UserListViewStream()
    private let disposeBag = DisposeBag()
    
    private let searchBar = UISearchBar(frame: .zero)
    private var data: [User] = []
    private var maxPageNum: Int = 1
    private var currentPageNum: Int = 1
    private var rowHeight: CGFloat = 136
    
    //lottieAnimation
    private var baseView = UIView()
    private let animationView = AnimationView()
    private let animation = Animation.named(AppConst.octocatAnim)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        self.setUserListVCConstraintAndDesign(infoLabel: self.infoLabel, tableView: self.tableView, baseView: self.baseView)
        self.setInitialState()
        self.bind()
        
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.startAnimation()
    }
}

extension UserListViewController {
    private func bind() {
        self.bindInput()
        self.bindOutput()
    }
    
    private func bindInput() {
        self.bindInputForSearchBar()
        self.bindInputForKeyboard()
        
        self.tableView.rx.itemSelected
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
        
        self.rightButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                SVProgressHUD.show()
                let nextPageNum = 1 + (self?.currentPageNum ?? 1)
                self?.viewModel.input.accept(nextPageNum, for: \.pageNum)
                self?.scrollToTop()
            }).disposed(by: disposeBag)
        
        self.leftButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                SVProgressHUD.show()
                let nextPageNum = -1 + (self?.currentPageNum ?? 1)
                self?.viewModel.input.accept(nextPageNum, for: \.pageNum)
                self?.scrollToTop()
            }).disposed(by: disposeBag)

        self.searchButton.rx.tap
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
    }
    
    private func bindInputForKeyboard() {
        KeyBoardHeightObservable.keyboardHeight()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (keyboardHeight) in
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
        self.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                
                self?.baseView.isHidden = true
                
                SVProgressHUD.show()
                
                self?.viewModel.input.accept(self?.searchBar.text, for: \.searchKeyword)
                self?.viewModel.input.accept(self?.currentPageNum, for: \.pageNum)
                
                self?.searchBar.resignFirstResponder()
                self?.searchBar.setShowsCancelButton(false, animated: true)
                
                self?.searchButton.imageView?.image = R.image.search()
                
            }).disposed(by: disposeBag)
        
        self.searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.searchBar.setShowsCancelButton(true, animated: true)
                self?.searchButton.imageView?.image = R.image.cancel()
            }).disposed(by: disposeBag)
        
        self.searchBar.rx.cancelButtonClicked
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
            .bind { [weak self] response in
                let totalCount = response ?? 0
                
                self?.updateInfoLabelAndPagingButtons(totalCount: totalCount)
                
            }.disposed(by: disposeBag)
        
        self.viewModel.output.errorMessage
            .bind(to: Binder(self) { me, message in
                
                SVProgressHUD.dismiss()
                
                self.showAlert(message: message, me: me)
                
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
        
        self.rightButton.isHidden = true
        self.leftButton.isHidden = true
        
        self.setSearchBar()
        self.setTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc
    private func startAnimation() {
        self.animateLottie(baseView: self.baseView, animationView: self.animationView, animation: self.animation, playSpeed: 1.0)
    }
    
    private func setSearchBar() {
        self.navigationItem.titleView = searchBar
        self.searchBar.placeholder = R.string.localizables.searchFromHere()
    }
    
    private func showEmptyView() {
        self.infoLabel.text = ""
    }
    
    private func setTableView() {
        self.tableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        self.rowHeight = screenSize.height / 8
        
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
        self.tableView.scrollToRow(at: topCellIndexPath, at: .top, animated: false)
    }
}

extension UserListViewController {
    private func showAlert(message: String?, me: UserListViewController) {
        let alert = UIAlertController(title: R.string.localizables.error(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizables.close(), style: .default, handler: nil))
        me.present(alert, animated: true, completion: nil)
    }
}

extension UserListViewController {
    
    private func updateInfoLabelAndPagingButtons(totalCount: Int) {
        var maxPageNum: Int = (totalCount / AppConst.perPageNum) + 1
        if totalCount <= AppConst.perPageNum {
            maxPageNum = 1
        }
        
        if totalCount == 0 {
            self.infoLabel.text = R.string.localizables.searchResults()
            self.leftButton.isHidden = true
            self.rightButton.isHidden = true
        } else if totalCount != 0 {
            if self.currentPageNum == 1 && maxPageNum == 1 {
                self.infoLabel.text = String(self.currentPageNum) + " / " + String(maxPageNum) + R.string.localizables.page()
                self.leftButton.isHidden = true
                self.rightButton.isHidden = true
            } else if self.currentPageNum == 1 && maxPageNum > 1 {
                self.infoLabel.text = String(self.currentPageNum) + " / " + String(maxPageNum) + R.string.localizables.page()
                self.leftButton.isHidden = true
                self.rightButton.isHidden = false
            } else if self.currentPageNum > 1 && self.currentPageNum < maxPageNum {
                self.infoLabel.text = String(self.currentPageNum) + " / " + String(maxPageNum) + R.string.localizables.page()
                self.leftButton.isHidden = false
                self.rightButton.isHidden = false
            } else if self.currentPageNum > 1 && self.currentPageNum == maxPageNum {
                self.infoLabel.text = String(self.currentPageNum) + " / " + String(maxPageNum) + R.string.localizables.page()
                self.leftButton.isHidden = false
                self.rightButton.isHidden = true
            }
        }
    }
}
