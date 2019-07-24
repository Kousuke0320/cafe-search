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

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.rx.text.orEmpty
            .map {$0.description}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)

    }
}

