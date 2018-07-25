//
//  QRcodeMaker.swift
//  Cardigin
//
//  Created by Luke on 2018-06-21.
//  Copyright © 2018 cardigin. All rights reserved.
//

import UIKit
class QRcode:NSObject{
    class func make(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
