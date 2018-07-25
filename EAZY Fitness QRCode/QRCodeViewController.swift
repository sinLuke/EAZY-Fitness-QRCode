//
//  QRCodeViewController.swift
//  EAZY Fitness QRCode
//
//  Created by Luke on 2018-07-19.
//  Copyright © 2018 Mike Chan. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    var qrcodeMemberID:String!
    var qrcodeImage:UIImage!
    let _refreshControl = UIRefreshControl()
    @IBOutlet weak var memberIDLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var qrcodeImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let _qrcodeMemberID = qrcodeMemberID {
            memberIDLabel.text = "Member ID: \(_qrcodeMemberID)"
        } else {
            self.close()
        }
        
        let gesture = UIGestureRecognizer(target: self, action: #selector(self.close))
        self.view.addGestureRecognizer(gesture)
        
        if let qrcodeImage = qrcodeImage {
            qrcodeImageView.image = qrcodeImage
        } else {
            Alert.show(title: "无法读取图片", err: "请稍后再试", handler: self.close, cvc: self)
        }
        self.addRefresh()
        // Do any additional setup after loading the view.
    }
    
    @objc func close(){
        self.dismiss(animated: true)
    }
    func addRefresh(){
        _refreshControl.isHidden = true
        _refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                  for: UIControlEvents.valueChanged)
        self.scrollView.addSubview(self._refreshControl)
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        self.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
