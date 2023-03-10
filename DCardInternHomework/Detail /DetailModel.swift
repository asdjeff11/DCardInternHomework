//
//  DetailModel.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/9.
//

import Foundation

struct LookUpResult:Codable {
    var resultCount:Int
    var results:[LookUpModel]
}

struct LookUpModel:Codable {
    var artistId:Int
    var collectionId:Int?
    var trackId:Int
    var artistName:String
    var collectionName:String?
    var trackName:String
    var artistViewUrl:String // 歌手預覽
    var collectionViewUrl:String? // 專輯預覽
    var previewUrl:String // 播放按鈕
    var artworkUrl100:String // url for pic
    var releaseDate:String
}
