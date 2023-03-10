//
//  LogoButton.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/9.
//

import Foundation
import UIKit

class LogoButton:UIButton {
    enum ButtonType {
        case Player
        case CD
        case Person
    }
    private let type:ButtonType
    private let fontColor = UIColor(hex: 0x5B5B5B)
    private let backGroundColor = UIColor(hex:0xE0E0E0)
    private let imgSize = CGSize(width: 30 * Theme.factor, height: 30 * Theme.factor)
    init(type:ButtonType, tintColor:UIColor? = nil ) {
        self.type = type
        super.init(frame: CGRect.zero)
        
        self.layer.cornerRadius = 8
        self.contentHorizontalAlignment = .leading
        
        var image = UIImage()
        var title = ""
        var picWidth = 0
        
        let myTintColor = tintColor == nil ? fontColor : tintColor!
        self.setTitleColor(myTintColor, for: .normal)
        
        switch ( type ) {
        case .CD :
            image = UIImage(named: "CDLogo")!
            title = "專輯預覽"
        case .Player :
            image = UIImage(named: "playerLogo")!
            title = "播放"
        case .Person :
            image = UIImage(named: "userLogo")!
            title = "歌手預覽"
        }
        
        let img = UIImage.scaleImage(image: image, newSize: imgSize)
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            
            configuration.attributedTitle = AttributedString(title,
                                                             attributes: AttributeContainer([
                                                                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18 * Theme.factor)
                                                             ]))
            configuration.image = img
            configuration.imagePadding = 8
            configuration.baseForegroundColor = myTintColor
            configuration.baseBackgroundColor = backGroundColor
            self.configuration = configuration
        }
        else {
            self.titleLabel?.font = .systemFont(ofSize: 20 * Theme.factor) // Theme.mainFont.withSize(20 * Theme.factor)
            
            
            
            self.backgroundColor = backGroundColor
            self.setImage(img, for: .normal)
            self.setTitle(title, for: .normal)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        }
      
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 150 * Theme.factor).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
