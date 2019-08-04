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
    //初期化をしないと表示されない
    init() {
        
    }
    var rest: [Rest]?
}

struct Rest: Codable {
    var name: String?
    var address: String?
}

//描画に使用
extension Article {
    init(_ json: [String: Any]) {
        if let article = json["rest"] as? [Rest] {
            self.rest = article
        }
    }
}

extension Rest {
    init(_ json: [String: Any]) {
        if let name = json["name"] as? String {
            self.name = name
        }
        if let address = json["address"] as? String {
            self.address = address
        }
    }
}

struct Qiita {
    
    
    static func fetchArticle(name: String?, completion: @escaping (Article?) -> Swift.Void) {
        
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

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    var articles: Article = Article()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView: do {
            tableView.frame = view.frame
            tableView.dataSource = self
            view.addSubview(tableView)
        }
        
        
        
        button.rx.tap.subscribe{ [unowned self] _ in
            Qiita.fetchArticle(name: self.textField.text, completion: { (articles) in
                guard let articleValue = articles else {
                    return
                }
                //なぜかnilがはいる
                self.articles = articleValue
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            })
            }.disposed(by: disposeBag)
        
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
        let article = articles
        let rest = article.rest?[indexPath.row]
        cell.textLabel?.text = rest?.name
        return cell
    }
    
    //cellの数をセットする
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let rest = articles?.rest else {
//            return 0
//        }
        return articles.rest?.count ?? 0
    }
}
