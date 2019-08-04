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
    var rest: [Rest]
}

struct Rest: Codable {
    var id: String
}

//extension Article {
////    init(_ json: [String: Any]) {
////        if let rest = json["rest"] as? [String: Any] {
////            if let id = rest["id"] as? String {
////                self.rest = id
////            }
////        }
////    }
//}

struct Qiita {
    
    static func fetchArticle(completion: @escaping (Article?) -> Swift.Void) {
        
        let url =  "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=68d888e65ff9a737216fd6d084c28179&name=tokyo"
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
                let article = try JSONDecoder().decode(Article.self, from: jsonData)
                print("\(article)")
                completion(article)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    var articles: Article?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        Qiita.fetchArticle(completion: { (articles) in
            guard let articleValue = articles else {
                return
            }
            
            self.articles?.rest = articleValue.rest
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        button.rx.tap.subscribe{ [unowned self] _ in
            self.tableView.reloadData()
            print("tapp")
            }
            .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .map {$0.description}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    //cellをセットする
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        let article = articles[indexPath.row]
//        cell.textLabel?.text = article.id
        //cell.detailTextLabel?.text = article.userId
        let article = articles?.rest[indexPath.row]
        cell.textLabel?.text = article?.id
        return cell
    }
    
    //cellの数をセットする
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.rest.count ?? 0
    }
}
