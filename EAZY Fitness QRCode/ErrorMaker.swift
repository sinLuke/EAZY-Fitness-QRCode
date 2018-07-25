//
//  ErrorMaker.swift
//  EAZY Fitness QRCode
//
//  Created by Luke on 2018-07-20.
//  Copyright © 2018 Mike Chan. All rights reserved.
//

import UIKit

class Alert: NSObject {
    class func show(title:String, err:String, handler:(()->())? = nil, cvc:UIViewController){
        let alert: UIAlertController = UIAlertController(title: title, message: err, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: {_ in
            if let _handler = handler{
                _handler()
            }
        }))
        cvc.present(alert, animated: true)
    }
}
