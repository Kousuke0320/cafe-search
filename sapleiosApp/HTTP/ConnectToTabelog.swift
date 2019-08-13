//
//  ConnectToTabelog.swift
//  sapleiosApp
//
//  Created by 田中康介 on 2019/08/10.
//  Copyright © 2019 田中康介. All rights reserved.
//

import Foundation

class ConnectToTabelog {
    let url =  "https://api.gnavi.co.jp/RestSearchAPI/v3/"
    
    func fetchArticle(name: String?, completion: @escaping (Article?) -> Swift.Void) {
        
        guard let name = name else {
            return
        }
        //URLが無効ならreturnを返す
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "keyid", value: "68d888e65ff9a737216fd6d084c28179"),
            URLQueryItem(name: "name", value: name)
        ]
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let article = try JSONDecoder().decode(Article.self, from: jsonData)
                //completion(article)
                completion(article)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //緯度経度で検索
    func fetchArticle(lat: Double?, lon: Double?, completion: @escaping (Article?) -> Swift.Void) {
        guard let lat = lat,
            let lon = lon else {
                return
        }
        
        //URLが無効ならreturnを返す
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "keyid", value: "68d888e65ff9a737216fd6d084c28179"),
            URLQueryItem(name: "latitude", value: String("\(lat)")),
            URLQueryItem(name: "longitude", value: String("\(lon)"))
        ]
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let article = try JSONDecoder().decode(Article.self, from: jsonData)
                //completion(article)
                completion(article)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

