//
//  OperationQueue.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/9.
//

import Foundation
import UIKit
class PendingOperations { // 追蹤每個operation狀態
    lazy var downloadsInProgress:[Int:Operation] = [:] // 用於跟蹤表中 每行的活動
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.qualityOfService = .background
        //queue.name = "download Image"
        queue.maxConcurrentOperationCount = 5 // 最高開到5個
        return queue
    }()
    
    func cancel(row:Int){
        self.downloadsInProgress[row]?.cancel()
        self.downloadsInProgress.removeValue(forKey: row)
    }
    
    func cancelAll(){
        _ = self.downloadsInProgress.map{ $0.value.cancel() }
        self.downloadsInProgress.removeAll()
    }
    
    func addTask(row:Int, downloader:Operation){
        self.downloadsInProgress[row] = downloader
        self.downloadQueue.addOperation(downloader)
    }
}

class ImageDownloader: Operation {
    var photoRecord:Photo
    init(_ photoRecord:Photo) {
        self.photoRecord = photoRecord
    }

    override func main() {
        if isCancelled {
            return
        }
        
        if photoRecord.state == .Done {
            return
        }
        else {
            let url = photoRecord.url
            if ( url == "" ) {
                photoRecord.state = .Failed
            }
            else if imgDict.isInDict(hash: url) { // 本地圖片 (在列隊前 沒有 , 列隊後出現了 , 代表前面可能有人撈了一樣的圖片 所以在此判斷有了就不撈取 , 降低連線次數)
                photoRecord.state = .Done
            }
            else {
                let group = DispatchGroup()
                group.enter()
                Task {
                    let result = await URLAction.action.getData(url_str: url) // getImage(url: url)
                    switch ( result ) {
                    case .failure(let error) :
                        print(error.localizedDescription)
                        photoRecord.state = .Failed
                    case .success(let data) :
                        guard let img = UIImage(data:data) else { photoRecord.state = .Failed ; return }
                        //let scaleImg = UIImage.scaleImage(image: img, newSize: CGSize(width: 200 * Theme.factor, height: 100 * Theme.factor)) // 為了降低空間
                        photoRecord.state = .Done
                        imgDict.putIntoDict(hash: url, imgs: [img])
                    }
                    group.leave()
                }
                group.wait()
            }
        }
    }
    
}
