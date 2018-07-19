//
//  ViewController.swift
//  EAZY Fitness QRCode
//
//  Created by Mike Chan on 7/19/18.
//  Copyright © 2018 Mike Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = "版本 v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

