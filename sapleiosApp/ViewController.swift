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
import Lottie
import CoreLocation

struct Article: Codable {
    //初期化をしないと表示されない
    init() {
        
    }
    var rest: [Rest]?
}

struct Rest: Codable {
    var name: String?
    var address: String?
    var image_url: Image?
}

struct Image: Codable {
    var shop_image1: String?
    var shop_image2: String?
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
        if let image_url = json["image_url"] as? Image {
            self.image_url = image_url
        }
    }
}

extension Image {
    init(_ json: [String: Any]) {
        
        if let shop_image1 = json["shop_image1"] as? String {
            self.shop_image1 = shop_image1
        }
        if let shop_image2 = json["shop_image2"] as? String {
            self.shop_image2 = shop_image2
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

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var locationManager: CLLocationManager!
    
    var articles: Article = Article()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        
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
                    self.showAnimation()
                }
                
            })
            }.disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .map {$0.description}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    func showAnimation() {
        let animationView = AnimationView(name: "Animation")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        view.addSubview(animationView)
        
        animationView.play()
    }
    
    func setupLocationManager() {
        //位置情報取得インスタンス
        locationManager = CLLocationManager()
        
        guard let locationManager = locationManager else {
            return
        }
        
        //位置情報取得をリクエスト
        locationManager.requestWhenInUseAuthorization()
        
        //
        let status = CLLocationManager.authorizationStatus()
        // 使用時に位置情報を許可した時に実施
        if status == .authorizedWhenInUse {
            //viewController自身をdelegate(向先に設定する)
             locationManager.delegate = self
            //10m単位で位置情報を取得する
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let lat = location?.coordinate.latitude
        let lon = location?.coordinate.longitude
        print("location\(lat)\(lon)")
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    //cellをセットする
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let article = articles
        let rest = article.rest?[indexPath.row]
        cell.textLabel?.text = rest?.name
//        if let url = rest?.image_url?.shop_image1 {
//            cell.imageView?.image = UIImage(named: url)
//        }
        guard let stringUrl = rest?.image_url?.shop_image1 else {
            return cell
        }
        
        let url = URL(string: stringUrl)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            cell.imageView?.image = image
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return cell
    }
    
    //cellの数をセットする
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let rest = articles?.rest else {
//            return 0
//        }
        return articles.rest?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
