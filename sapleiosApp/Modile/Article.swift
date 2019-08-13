//
//  Article.swift
//  sapleiosApp
//
//  Created by 田中康介 on 2019/08/10.
//  Copyright © 2019 田中康介. All rights reserved.
//

import Foundation
struct Article: Codable {
    //初期化をしないと表示されない
    init() {
        
    }
    var rest: [Rest]?
}

//描画に使用
extension Article {
    init(_ json: [String: Any]) {
        if let article = json["rest"] as? [Rest] {
            self.rest = article
        }
    }
}

