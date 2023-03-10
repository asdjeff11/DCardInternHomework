//
//  DetailView.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit
class DetailView:CustomViewController {
    var viewModel:DetailViewModel!
    private var imageView = UIImageView()
    private var collectionNameLabel = UILabel.createLabel(size: 22, color: .black)
    private var artistNameLabel = UILabel.createLabel(size: 18, color: .black)
    private var trackNameLabel = UILabel.createLabel(size: 18, color: .black)
    private var releaseLabel = UILabel.createLabel(size: 18, color: .black)
    
    private var artistEditBtn = LogoButton(type: .Person)
    private var collectionEditBtn = LogoButton(type: .CD)
    private var songEditBtn = LogoButton(type: .Player)
    
    private var stackView_lb:UIStackView!
    private var stackView_btn:UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()

        viewModel.getLookUpData(type: .spinnerLoading)
    }
    
}


extension DetailView {
    func setUp() {
        setUpNav(title: "詳細頁面")
        view.backgroundColor = UIColor(hex: 0x00324e)
        artistEditBtn.addTarget(self, action: #selector(artistBtnAct), for: .touchUpInside)
        collectionEditBtn.addTarget(self, action: #selector(collectionBtnAct), for: .touchUpInside)
        songEditBtn.addTarget(self, action: #selector(songEditBtnAct), for: .touchUpInside)
        
        viewModel.delegate = self
    }
    
    func layout() {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 15
        bgView.layer.borderColor = UIColor.black.cgColor
        bgView.layer.borderWidth = 1
        stackView_lb = UIStackView(arrangedSubviews: [collectionNameLabel,artistNameLabel,trackNameLabel,releaseLabel])
        stackView_lb.axis = .vertical
        stackView_lb.spacing = 30 * Theme.factor
        stackView_lb.distribution = .equalSpacing
        
        stackView_btn = UIStackView(arrangedSubviews: [artistEditBtn,collectionEditBtn,songEditBtn] )
        stackView_btn.axis = .horizontal
        stackView_btn.spacing = 30 * Theme.factor
        stackView_btn.distribution = .equalSpacing
        
        let lineView = UIView()
        lineView.backgroundColor = .black
        view.addSubview(bgView)
        bgView.addSubviews(imageView,lineView, stackView_lb , stackView_btn )
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            bgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bgView.topAnchor.constraint(equalTo: margins.topAnchor,constant: 30 * Theme.factor ),
            bgView.bottomAnchor.constraint(equalTo: margins.bottomAnchor,constant: -30 * Theme.factor),
            bgView.widthAnchor.constraint(equalTo:margins.widthAnchor,constant: 0.95),
            
            imageView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: bgView.topAnchor,constant: 30 * Theme.factor),
            imageView.widthAnchor.constraint(equalToConstant: 250 * Theme.factor),
            imageView.heightAnchor.constraint(equalToConstant: 250 * Theme.factor),
            
            lineView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 30 * Theme.factor),
            lineView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            lineView.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 0.8),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            stackView_lb.topAnchor.constraint(equalTo: lineView.bottomAnchor,constant: 30 * Theme.factor),
            stackView_lb.leadingAnchor.constraint(equalTo: lineView.leadingAnchor,constant: 10 * Theme.factor),
            //stackView_lb.bottomAnchor.constraint(equalTo:stackView_btn.topAnchor,constant: -70 * Theme.factor),
            stackView_lb.trailingAnchor.constraint(equalTo: lineView.trailingAnchor,constant: -10 * Theme.factor),
            
            stackView_btn.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            stackView_btn.bottomAnchor.constraint(equalTo: bgView.bottomAnchor,constant: -30 * Theme.factor),
            stackView_btn.heightAnchor.constraint(equalToConstant: 50 * Theme.factor)
        ])
    }
}

extension DetailView {
    @objc func artistBtnAct() {
        guard let url_str = viewModel.getArtistViewUrl() else { return }
        let vc = WebView()
        vc.url_str = url_str
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func collectionBtnAct() {
        guard let url_str = viewModel.getCollectionViewUrl() else { return }
        let vc = WebView()
        vc.url_str = url_str
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func songEditBtnAct() {
        guard let detail = viewModel.getDetail() else { return }
        let vc = PlayerPopUp()
        vc.detail = detail
        addViewToPresent(viewController: vc)
    }
}

extension DetailView:DetailDelegate {
    override func fetchCallBack() {
        collectionNameLabel.text = "專輯名稱: \(viewModel.getCollectionName())"
        artistNameLabel.text = "歌手: \(viewModel.getArtistName())"
        trackNameLabel.text = "歌曲名稱: \(viewModel.getTrackName())"
        releaseLabel.text = "發行日期: \(viewModel.getReleaseDate())"
        
        if ( viewModel.getCollectionViewUrl() == nil ) {
            stackView_btn.removeArrangedSubview(collectionEditBtn)
            collectionEditBtn.removeFromSuperview()
        }
        
        if ( viewModel.getCollectionName() == "" ) {
            stackView_lb.removeArrangedSubview(collectionNameLabel)
            collectionNameLabel.removeFromSuperview()
        }
    }
    
    func setImage(_ img: UIImage) {
        self.imageView.image = img
    }
}
