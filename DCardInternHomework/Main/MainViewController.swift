//
//  MainViewController.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit
class MainViewController:CustomViewController {
    private let viewModel = MainViewModel()
    
    lazy private var searchBtn:UIButton = {
        let button = UIButton()
        button.createSearchBtn()
        button.addTarget(self, action: #selector(searchBtnAct), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x00324e)
        NotificationCenter.default.addObserver(self, selector:#selector(backToApp), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(onBackGround), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        setUpNav(title: "iTunes Search API",rightButton: searchBtn, homeButtonRemove: true)
        setUp()
        layout()
        viewModel.updateData(type: .spinnerLoading)
    }
}


extension MainViewController {
    private func setUp() {
        viewModel.delegate = self
        
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(MainCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "space")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layout() {
        let margins = view.layoutMarginsGuide
        view.addSubview(tableView)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30 * Theme.factor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor,constant: -30 * Theme.factor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension MainViewController {
    @objc private func searchBtnAct() {
        if isLoading { return }
        
        let vc = SearchPopUp()
        vc.callBackToView = { [weak self] ( searchCondition:SearchSongCondition ) in
            self?.viewModel.setSearchCondition(searchCondition)
            self?.viewModel.updateData(type: .spinnerLoading)
        }
        addViewToPresent(viewController: vc)
    }
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getLen() * 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ( indexPath.row % 2 == 0 ) ? 30 * Theme.factor : 200 * Theme.factor
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ( indexPath.row % 2 == 0 ) {
            let space = tableView.dequeueReusableCell(withIdentifier: "space")!
            space.backgroundColor = .clear
            space.isUserInteractionEnabled = false
            return space
        }
        
        let row = indexPath.row / 2
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MainCell ,
              let item_detail = viewModel.getDetail(row: row) ,
              let item_photo = viewModel.getPhoto(row: row)
        else { return UITableViewCell() }
        
        
        cell.selectionStyle = .none
        cell.setUpImage(img: nil) // 圖片重設 怕會有影像殘留
        cell.setUpData(detail: item_detail)
        
        // later set Image
        if ( imgDict.isInDict(hash: item_photo.url) ) { // 狀態為已完成 才顯示 , 其餘等到Task完成後刷新顯示
            cell.setUpImage(img: imgDict.getImg(hash: item_photo.url))
        }
        else if ( item_photo.state == .Failed ) { // 撈取圖片失敗
            cell.setUpImage(img: UIImage(named: "noPic"))
        }
        
        
        if ( row > (viewModel.getLen() - 6) ) { // 當倒數第6個cell 顯示時
            if ( !viewModel.isLoading && !viewModel.isNothingToGet ) { // 不在載入狀態 且 還有其他資料可以抓取 
                if ( self.taskID != nil ) { // 上一份延長時間如果沒取消  則幫忙取消 taskID
                    endBackgroundUpdateTask(taskID: taskID )
                }
                viewModel.updateData(type: .noLoading) // 載入新資訊
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row / 2
        guard let item_detail = viewModel.getDetail(row: row) else { return }
        
        let ISO = viewModel.getISO()
        let vc = DetailView()
        vc.viewModel = DetailViewModel(detail: item_detail,countryCode: ISO)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController:ImageListDelegate {
    func updateCell(_ row: Int,_ photo:Photo) {
        //tableView.reloadData()
        
        let indexPath = IndexPath(row: row * 2 + 1, section: 0) // *2 because of space
        guard let cell = tableView.cellForRow(at: indexPath) as? MainCell else { return }
        cell.setUpImage(img: imgDict.getImg(hash: photo.url))
    }
}

extension MainViewController {
    @objc func onBackGround() {
        imgDict.onBackGround(photos: viewModel.getTotalPhotos())
    }
    
    @objc func backToApp() {
        imgDict.onFrontGround()
    }
}
