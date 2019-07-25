//
//  ViewController.swift
//  sapleiosApp
//
//  Created by 田中康介 on 2019/07/10.
//  Copyright © 2019 田中康介. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Article: Codable {
    var title: String?
    var user: User
    struct User: Codable {
        var id: String
    }
}



class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    var article: [Article] = []
    var a = 0
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.global().async {
                Qiita.fetchArticle { (article) in
                    //self.article = article
                }
                DispatchQueue.main.async {
//                    if !(self.article.isEmpty) {
//                        self.label.text = self.article[0].title
//                        //print(self.article[0].title)
//                        print("aaa")
//                    }
                }
            }
        
        
        textField.rx.text.orEmpty
            .map {$0.description}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)

    }
    
    
    struct Qiita {
        
        static func fetchArticle(completion: @escaping ([Article]) -> Swift.Void) {
        
        let url =  "https://qiita.com/api/v2/items"
        
        //URLが無効ならreturnを返す
        guard var urlComponents = URLComponents(string: url) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "50")
        ]
            let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
                
                guard let jsonData = data else {
                    return
                }
                
                do {
                    let article = try JSONDecoder().decode([Article].self, from: jsonData)
                    print("\(article)")
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
}
