//
//  MainCell.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit
class MainCell:UITableViewCell {
    private let myImageView = UIImageView()
    private let collectionNameLabel = UILabel.createLabel(size: 28 * Theme.factor, color: .black)
    private let artistNameLabel = UILabel.createLabel(size: 22 * Theme.factor, color: .black)
    private let trackNameLabel = UILabel.createLabel(size: 22 * Theme.factor, color: .black)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 15
        
        
        let stackView = UIStackView(arrangedSubviews: [collectionNameLabel,artistNameLabel,trackNameLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        contentView.addSubview(bgView)
        bgView.addSubviews(myImageView,stackView)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 30 * Theme.factor),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -30 * Theme.factor),
            
            myImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor,constant: 30 * Theme.factor) ,
            myImageView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 150 * Theme.factor),
            myImageView.heightAnchor.constraint(equalToConstant: 150 * Theme.factor),
        
            stackView.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor,constant: 30 * Theme.factor),
            stackView.topAnchor.constraint(equalTo: myImageView.topAnchor ),
            stackView.bottomAnchor.constraint(equalTo: myImageView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor,constant: -30 * Theme.factor)
        ])
    }
    
    func setUpData(detail:SongDetail) {
        collectionNameLabel.text = detail.collectionName
        artistNameLabel.text = detail.artistName
        trackNameLabel.text = detail.trackName
    }
    
    func setUpImage(img:UIImage?) {
        myImageView.image = img
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
