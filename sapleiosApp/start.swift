//
//  start.swift
//  sapleiosApp
//
//  Created by 田中康介 on 2019/08/06.
//  Copyright © 2019 田中康介. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class start: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimation()
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
}
