//
//  Rest.swift
//  sapleiosApp
//
//  Created by 田中康介 on 2019/08/10.
//  Copyright © 2019 田中康介. All rights reserved.
//

import Foundation

struct Rest: Codable {
    var name: String?
    var address: String?
    var image_url: Image?
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

