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
    var title: String = ""
    //var userId: String = ""
}

extension Article {
    init(_ json: [String: Any]) {
        
        if let title = json["title"] as? String {
            self.title = title
        }
        
//        if let user = json["user"] as? [String: Any] {
//            if let userId = user["id"] as? String {
//                self.userId = userId
//            }
//        }
    }
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
    
    
    var articles: [Article] = []
    var a = 0
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        Qiita.fetchArticle(completion: { (articles) in
            self.articles = articles
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
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.title
        //cell.detailTextLabel?.text = article.userId
        return cell
    }
    
    //cellの数をセットする
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
}
