//
//  Image.swift
//  sapleiosApp
//
//  Created by 田中康介 on 2019/08/10.
//  Copyright © 2019 田中康介. All rights reserved.
//

import Foundation

struct Image: Codable {
    var shop_image1: String?
    var shop_image2: String?
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

