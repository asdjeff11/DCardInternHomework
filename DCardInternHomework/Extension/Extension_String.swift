//
//  Extension_String.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/6/20.
//

import Foundation
extension String {
    func positionOf(sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    func jsonToDictionary() throws -> [String: Any] {
        guard let data = self.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: Any] ?? [:]
    }
}
