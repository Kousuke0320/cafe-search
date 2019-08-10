//
//  ConnectToTabelog.swift
//  sapleiosApp
//
//  Created by 田中康介 on 2019/08/10.
//  Copyright © 2019 田中康介. All rights reserved.
//

import Foundation

class ConnectToTabelog {
    func fetchArticle(name: String?, completion: @escaping (Article?) -> Swift.Void) {
        
        guard let name = name else {
            return
        }
        
        let url =  "https://api.gnavi.co.jp/RestSearchAPI/v3/"
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
}

