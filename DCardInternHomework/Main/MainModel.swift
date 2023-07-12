//
//  MainModel.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/8.
//

import Foundation
import UIKit

struct SongResult:Codable {
    var resultCount:Int
    var results:[SongDetail]
}

struct SongDetail:Codable,Hashable {
    //var wrapperType:String
    //var kind:String
    var artistId:Int
    var collectionId:Int? // 有些沒有
    var trackId:Int
    var artistName:String
    var collectionName:String?
    var trackName:String
    //var collectionCensoredName:String
    //var trackCensoredName:String
    var artistViewUrl:String // 歌手預覽
    var collectionViewUrl:String? // 專輯預覽
    //var trackViewUrl:String
    var previewUrl:String // 播放按鈕
    //var artworkUrl30:String
    //var artworkUrl60:String
    var artworkUrl100:String // url for pic
    //var collectionPrice:Float
    //var trackPrice:Float
    var releaseDate:String
    //var collectionExplicitness:String
    //var trackExplicitness:String
    //var discCount:Int
    //var discNumber:Int
    //var trackCount:Int
    //var trackNumber:Int
    //var trackTimeMillis:Double
    var country:String
    //var currency:String
    //var primaryGenreName:String
    //var isStreamable:Bool
    
    static func == (lhs: SongDetail, rhs: SongDetail) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
        hasher.combine(trackName)
        hasher.combine(artistId)
    }
}

struct SearchSongCondition {
    var term:String
    var country:String?
    let media = "music"
    func getUrl(offset:Int,limit:Int)->String {
        var url = "https://itunes.apple.com/search?"
        url += "term=\(term)"
        url += "&media=\(media)"
        if let country = country {
            url += "&country=\(country)"
        }
        
        url += "&offset=\(offset)"
        url += "&limit=\(limit)"
        
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

struct Photo { // 背景拉圖
    enum State {
        case NotDone,Done,Failed
    }
    
    var state:State = .NotDone
    var url:String = ""
    // 在此不放圖片 , 因為若陣列很長 會一直有重複圖片出現
    // 造成更多 memory 壓力
    // 故 一率放 imgDict , 並從 imgDict 拿取
    // 好處是 1.不用儲存重複圖片 , 2.圖片可以跨頁面拿取
    // 可以大幅降低 與 server連線次數 以及 降低存圖的空間
    /* var image:UIImage? */
}

extension Data {
    var integer: Int {
        return withUnsafeBytes { $0.load(as: Int.self) }
    }
    var int32: Int32 {
        return withUnsafeBytes { $0.load(as: Int32.self) }
    }
    var float: Float {
        return withUnsafeBytes { $0.load(as: Float.self) }
    }
    var double: Double {
        return withUnsafeBytes { $0.load(as: Double.self) }
    }
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
    
    // data -> Hex String
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
    
    func fourBytesToInt()->Int {
        var value : UInt32 = 0
        let data = self.reserve()
        
        let nsData = NSData(bytes: [UInt8](data), length: self.count)
        nsData.getBytes(&value, length: self.count)
        value = UInt32(bigEndian: value)
        return Int(value)
    }
    
    func reserve()->Data {
        let count:Int = self.count ;
        var array = Data(count:count)
        for i in 0..<count {
            array[i] = self[count - 1 - i]
        }
        
        return array
    }
}


