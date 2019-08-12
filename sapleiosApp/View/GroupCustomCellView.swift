//
//  GroupCustomCellView.swift
//  sapleiosApp
//
//  Created by 田中康介 on 2019/08/12.
//  Copyright © 2019 田中康介. All rights reserved.
//

import Foundation
import UIKit

class GroupCustomCellView: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCustomCell(label: String?, image: UIImage?) {
        self.cellLabel.text = label
        self.cellImage.image = image
    }
    
}


