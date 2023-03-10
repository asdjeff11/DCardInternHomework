//
//  URLAction.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/9.
//

import Foundation
class URLAction {
    static let action = URLAction()
    public func getObject<T:Codable>(url_str:String) async -> Result<T,URLConnectError> {
        guard let url = URL(string:url_str)  else { return .failure(URLConnectError.invalidUrl)  }
        
        guard let (data,response) = try? await URLSession.shared.data(from:url),
              let response = response as? HTTPURLResponse else { return .failure(URLConnectError.invalidResponse) }
        
        guard (200...299).contains(response.statusCode) else { print("errorCode:\(response.statusCode)") ; return .failure(URLConnectError.invalidResponse)}
             
        let jsonDecoder = JSONDecoder()
        do {
            let object:T = try jsonDecoder.decode(T.self, from: data)
            return .success(object)
        }
        catch {
            print(error)
            return .failure(URLConnectError.invalidData)
        }
    }
    
    public func getData(url_str:String) async -> Result<Data,URLConnectError> {
        guard let url = URL(string:url_str)  else { return .failure(URLConnectError.invalidUrl)  }
        
        guard let (data,response) = try? await URLSession.shared.data(from:url),
              let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else { return .failure(URLConnectError.invalidResponse) }
        return .success(data)
    }
    
}
