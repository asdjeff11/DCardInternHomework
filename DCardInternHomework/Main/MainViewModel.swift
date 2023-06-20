//
//  MainViewModel.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation

protocol ImageListDelegate:BaseDelegate {
    func updateCell(_ :Int,_ :Photo)
}

class MainViewModel {
    private var songDetailList = [SongDetail]() // 各列資訊
    private var photos = [Photo]() // 各列的圖片撈取狀態
    private var searchCondition = SearchSongCondition(term: "MayDay") // 篩選條件 ( default : name:Mayday , country:nil
    weak var delegate:ImageListDelegate?
    
    private var pendingOperations = PendingOperations() // thread池
    
    private final let limit = 20 // 每次撈取資料數量  需要更多 修改此值
    private var offset = 0 // 下次要取的起始位置
    
    var isNothingToGet = false // 是否已經沒有資訊了 ( 不確定這是否有此case )
    var isLoading = false // 是否Operation將懸置
    
    
    func setSearchCondition(_ condition:SearchSongCondition) {
        self.searchCondition = condition
        pendingOperations.cancelAll()
        songDetailList.removeAll()
        photos.removeAll()
        isNothingToGet = false
        offset = 0
    }
    
    func updateData(type:LoadingStyle) {
        if ( isLoading || isNothingToGet ) { return }
        
        isLoading = true
        let url_str = searchCondition.getUrl(offset: offset, limit: limit)
        
        delegate?.startProcess(type)
        Task.detached(priority: .background) {
            let myData:Result<SongResult,URLConnectError> = await URLAction.action.getObject(url_str:url_str)
            switch ( myData ) {
            case .success(let resultsObject) :
                if ( resultsObject.resultCount == 0 ) { self.isNothingToGet = true  } // 沒新資料
                else {
                    for result in resultsObject.results {
                        self.songDetailList.append(result)
                        self.addPhotoTaskToFetchImg(detail: result)
                        //self.photos.append(Photo(url: result.artworkUrl100))
                    }
                }
                self.offset += self.limit
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
                self.delegate?.reloadData()
                self.isLoading = false
            })
        }
    }
}

extension MainViewModel { // getImg
    func addPhotoTaskToFetchImg(detail:SongDetail) {
        let imgUrl = detail.artworkUrl100
        if !imgDict.checkImgExist(url: imgUrl) {
            let photo = Photo(url:imgUrl)
            let imageTask = ImageDownloader(photo)
            self.photos.append(photo)
            let row = photos.count - 1
            
            imageTask.completionBlock = { // ImageDownLoader main 結束後 執行
                DispatchQueue.main.async { // 刷新cell
                    self.pendingOperations.downloadsInProgress.removeValue(forKey: row) // 移除列隊標記
                    
                    if ( imageTask.isCancelled ) { return }
                    
                    self.photos[row].state = imageTask.photoRecord.state
                    // 執行結束 後續動作
                    self.delegate?.updateCell(row,self.photos[row])
                }
            }
            
            pendingOperations.addTask(row: row, downloader: imageTask)
        }
        else {
            self.photos.append(Photo(state:.Done, url:imgUrl))
        }
    }
}


extension MainViewModel {
    func getLen()->Int {
        return songDetailList.count
    }
    
    func getDetail(row:Int)->SongDetail? {
        return ( row < songDetailList.count ) ? songDetailList[row] : nil
    }
    
    func getPhoto(row:Int)->Photo? {
        return ( row < photos.count ) ? photos[row] : nil
    }
    
    func getTotalPhotos()->[Photo] { // 用來暫存使用
        return photos
    }
    
    func getISO()->String? {
        return searchCondition.country
    }
}
