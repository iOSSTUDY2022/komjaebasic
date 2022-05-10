//
//  ViewController.swift
//  HelloWorld
//
//  Created by 이형주 on 2022/04/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var uiTitle: UILabel!
    
    @IBAction func sayHello(_ sender: UIButton) {
        self.uiTitle.text = "Hello, World!"
    }
}

