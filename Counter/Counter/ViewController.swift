//
//  ViewController.swift
//  Counter
//
//  Created by Данил Красноперов on 24.04.2024.
//

import UIKit

class ViewController: UIViewController {
    var currentCount: Int = 0

    @IBAction func changeButton(_ sender: Any) {
        currentCount+=1
        countLabel.text = ("Значение счетчика =\(currentCount) ")
    }
    @IBOutlet weak var countLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


}

