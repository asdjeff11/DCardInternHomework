//
//  ImageRegister.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/9.
//

import Foundation
import UIKit

let imgDict = ImageDataBase()
class ImageDataBase {
    class ImageObj {
        var image = [UIImage]()
        init(imgs:[UIImage]) {
            self.image = imgs
        }
    }
    
    private var images = NSCache<NSString,ImageObj>()
    private var images_index:[String:ImageObj] = [:]
    private var semphore = DispatchSemaphore(value: 1)
    
    
    
    func putIntoDict(hash:String,imgs:[UIImage]) {
        semphore.wait()
        defer {
            semphore.signal()
        }
        images.setObject(ImageObj(imgs:imgs), forKey: hash as NSString)
    }
    
    func getImgs(hash:String)->[UIImage]? { // 拿圖片集

        if let imageObj = images.object(forKey: hash as NSString) {
            return imageObj.image
        }
        else {
            return nil
        }
    }
    
    func getImg(hash:String, size:CGSize? = nil)->UIImage? { // 拿單張

        if let imageObj = images.object(forKey: hash as NSString) , imageObj.image.isEmpty == false {
            return ( size == nil ? imageObj.image[0] : UIImage.scaleImage(image: imageObj.image[0], newSize: size!) )
        }
        else {
            return nil
        }
    }
    
    func isInDict(hash:String)->Bool { return images.object(forKey: hash as NSString) != nil }
    
    
    func onBackGround(photos:[Photo]) { // 保留當前的圖片 其餘的 remove掉 , 在OS優化上 NSCache 會主動 移除他們
        for photo in photos {
            if let imgObj = images.object(forKey: photo.url as NSString) {
                images_index[photo.url] = imgObj
            }
        }
        images.removeAllObjects()
    }
    
    func onFrontGround() { // 恢復之前的圖片 
        for entry in images_index {
            let hash = entry.key as NSString
            let imgObj = entry.value
            images.setObject(imgObj, forKey: hash)
        }
        images_index.removeAll()
    }
}
