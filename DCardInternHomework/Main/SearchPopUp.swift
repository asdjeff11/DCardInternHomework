//
//  SearchPopUp.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit

class SearchPopUp: UIViewController {
    struct ISOData:Decodable {
        var name:String
        var code:String
    }
    
    private var searchCondition = SearchSongCondition(term: "")
    var callBackToView:((_:SearchSongCondition)->Void)?
    
    private var ISOList:[ISOData] = []
    
    private var pickerView = UIPickerView()
    
    private let songerTextField = LabelTextField(labelName: "歌手:", textSize: 30 * Theme.factor, textColor: UIColor(hex: 0x5B5B5B))
    private let countryTextField = LabelTextField(labelName: "國家:", textSize: 30 * Theme.factor, textColor: UIColor(hex: 0x5B5B5B))
    private let confirmBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCountry()
        setUp()
        layout()
    }
    
    
    private func setUpCountry() {
        guard let path = Bundle.main.path(forResource: "ISO", ofType: "json") else { return }
        let localData = NSData.init(contentsOfFile: path)! as Data
        do {
            // banner即为我们要转化的目标model
            ISOList = try JSONDecoder().decode([ISOData].self, from: localData)
        } catch {
            debugPrint("ISO===ERROR")
        }
    }
    
    private func setUp() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)) //  close keyboard
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
        
        songerTextField.setTextField(color: nil, hint: "MayDay", hintColor: UIColor(hex: 0xA9A9A9))
        countryTextField.setTextField(color: nil, hint: "請選擇國家(可以不選)", hintColor: UIColor(hex: 0xA9A9A9))
        
        countryTextField.textField.inputView = pickerView
        countryTextField.textField.delegate = self
        pickerView.delegate = self
        
        confirmBtn.titleLabel?.font = .systemFont(ofSize: 16)
        confirmBtn.layer.cornerRadius = 15
        confirmBtn.setTitle("確認", for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.backgroundColor = Theme.navigationBarBG
        confirmBtn.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        
    }
    
    private func layout() {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 500 * Theme.factor , height: 600 * Theme.factor))
        contentView.backgroundColor = .white
        contentView.center = CGPoint(x: UIScreen.main.bounds.width/2, y:  UIScreen.main.bounds.height/2)
        contentView.layer.cornerRadius = 8
        contentView.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        self.view.addSubview(contentView)
        
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        closeButton.setImage(#imageLiteral(resourceName: "button_close.png"), for: .normal)
        closeButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
        
        let titleLabel = UILabel.createLabel(size: 24, color: .black,text:"搜尋內容")
        
        let lineView = UIView()
        lineView.backgroundColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [countryTextField, songerTextField])
        stackView.distribution = .equalSpacing
        stackView.spacing = 30 * Theme.factor
        stackView.axis = .vertical
        
        contentView.addSubviews(titleLabel ,closeButton ,lineView ,stackView,confirmBtn )
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 30 * Theme.factor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40 * Theme.factor),
            
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20 * Theme.factor),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40 * Theme.factor),
            closeButton.heightAnchor.constraint(equalToConstant: 40 * Theme.factor),
            
            lineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20 * Theme.factor),
            lineView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: lineView.bottomAnchor,constant: 30 * Theme.factor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: (CGFloat(stackView.subviews.count * 2 - 1) * 40) * Theme.factor ),
            stackView.widthAnchor.constraint(equalToConstant:  350 * Theme.factor),
            
            confirmBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmBtn.heightAnchor.constraint(equalToConstant: 50 * Theme.factor),
            confirmBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -30 * Theme.factor),
            confirmBtn.widthAnchor.constraint(equalToConstant: 150 * Theme.factor)
        ])
    }
    
    @objc private func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    @objc private func sendAction() {
        guard let songer = songerTextField.textField.text , songer != "" else {
            showAlert(alertText: "提醒", alertMessage: "請填寫歌手名稱")
            return
        }
        
        searchCondition.term = songer

        callBackToView?(searchCondition)
        dismiss(animated: true)
    }
   
    @objc private func close() { // close keyboard
        self.dismiss(animated: true)
    }
    
}

extension SearchPopUp:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ( self.searchCondition.country == nil ) { // default 設定
            self.countryTextField.textField.text = ISOList[0].name
            self.searchCondition.country = ISOList[0].code
        }
    }
}

extension SearchPopUp: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ISOList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ISOList[row].name
    }
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countryTextField.textField.text = ISOList[row].name
        self.searchCondition.country = ISOList[row].code
    }
}
