//
//  DetailViewModel.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit

protocol DetailDelegate:BaseDelegate {
    func setImage(_:UIImage)
}

class DetailViewModel {
    private let detail:SongDetail
    private let countryCode:String?
    
    weak var delegate:DetailDelegate?
    private var lookUpModel:LookUpModel?
    
    init(detail:SongDetail, countryCode:String? = nil) {
        self.detail = detail
        self.countryCode = countryCode
    }
}

extension DetailViewModel { // get LookUp
    func getLookUpData(type:LoadingStyle) {
        delegate?.startProcess(type)
        let ISO = ( countryCode == nil ) ? "" : "\(countryCode!)/"
        let url_str = "https://itunes.apple.com/\(ISO)lookup?id=\(detail.trackId)"
        Task.detached(priority:.background) {
            let myData:Result<LookUpResult,URLConnectError> = await URLAction.action.getObject(url_str:url_str)
            switch ( myData ) {
            case .success(let resultsObject) :
                self.lookUpModel = (resultsObject.results.count > 0 ) ? resultsObject.results[0] : nil
                self.getImage()
            case .failure(let error) :
                switch ( error ) {
                case .invalidData :
                    self.delegate?.showAlertFrame("資料錯誤", "取得資訊錯誤", nil)
                case .invalidResponse :
                    self.delegate?.showAlertFrame("資料錯誤", "取得回傳狀態錯誤", nil)
                case .invalidUrl :
                    self.delegate?.showAlertFrame("資料錯誤", "url轉碼失敗", nil)
                case .requestFailed(let errorMsg):
                    self.delegate?.showAlertFrame("資料錯誤", "錯誤資訊 :\(errorMsg)", nil)
                }
            }
            
            Task.detached(operation:{@MainActor in
                self.delegate?.endProcess(type)
                self.delegate?.fetchCallBack()
            })
        }
    }
}


extension DetailViewModel { // get Image
    func getImage() {
        guard let url = lookUpModel?.artworkUrl100 else { return }
        
        if ( imgDict.isInDict(hash: url) ) { // 暫存器有 就不用拉了 減少連接
            Task.detached(operation: { @MainActor [weak self] in
                self?.delegate?.setImage(imgDict.getImg(hash: url)!)
            })
            return
        }
        
        Task.detached(priority: .background) {
            let resultData = await URLAction.action.getData(url_str: url)
            switch ( resultData ) {
            case .failure(let error) :
                print(error.localizedDescription)
            case .success(let data) :
                guard let img = UIImage(data:data) else { return }
                //let scaleImg = UIImage.scaleImage(image: img, newSize: CGSize(width: 250 * Theme.factor, height: 250 * Theme.factor)) // 為了降低空間
                imgDict.putIntoDict(hash: url, imgs: [img])
                Task.detached(operation: { @MainActor [weak self] in
                    self?.delegate?.setImage(img)
                })
            }
        }
    }
}

extension DetailViewModel {
    func getCollectionName()->String { return lookUpModel?.collectionName ?? "" }
    func getArtistName()->String { return lookUpModel?.artistName ?? "" }
    func getTrackName()->String { return lookUpModel?.trackName ?? "" }
    func getReleaseDate()->String {
        // 轉換 date
        guard let date = lookUpModel?.releaseDate , date.count >= 10 else { return "" }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        guard let myDate = dateFormat.date(from: String(date.prefix(10))) else { return date }
        
        dateFormat.dateFormat = "yyyy年MM月dd日"
        
        return dateFormat.string(from: myDate)
    }
    
    func getDetail()->LookUpModel? { return lookUpModel }
    func getArtistViewUrl()->String? { return lookUpModel?.artistViewUrl }
    func getCollectionViewUrl()->String? { return lookUpModel?.collectionViewUrl }
    func getPreviewUrl()->String? { return lookUpModel?.previewUrl }
}
