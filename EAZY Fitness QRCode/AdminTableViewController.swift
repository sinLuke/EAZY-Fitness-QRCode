//
//  AdminTableViewController.swift
//  EAZY Fitness QRCode
//
//  Created by Luke on 2018-07-19.
//  Copyright © 2018 Mike Chan. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AdminTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var MemberList : [String:String] = [:]
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tabelView: UITableView!
    
    var selectedMemberID: String?
    var selectedQRImage: UIImage?
    
    var loading: Bool = false{
        didSet{
            self.activity.isHidden = !loading
            if loading {
                self.activity.startAnimating()
            } else {
                self.activity.stopAnimating()
            }
        }
    }
    
    let _refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addRefresh()
        refresh()
        
        self.loading = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.MemberList.count
    }
    
    func addRefresh(){
        let title = NSLocalizedString("下拉刷新", comment: "下拉刷新")
        _refreshControl.attributedTitle = NSAttributedString(string: title)
        _refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                  for: UIControlEvents.valueChanged)
        self.tabelView.addSubview(self._refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        refreshControl.endRefreshing()
        self.refresh()
    }
    
    func refresh() {
        self.loading = true
        Firestore.firestore().collection("QRCODE").getDocuments { (snap, err) in
            self.loading = false
            if let snap = snap {
                for docs in snap.documents {
                    if let MemberID = docs.data()["MemberID"] as? String{
                        if self.MemberList[MemberID] == nil {
                            self.MemberList[MemberID] = docs.documentID
                        }
                    }
                }
            }
            self.tabelView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let qrcodeString = self.MemberList.keys.sorted()[indexPath.row]
        cell.detailTextLabel?.text = self.MemberList[qrcodeString]
        cell.detailTextLabel?.textColor = UIColor.gray
        cell.textLabel?.text = "\(qrcodeString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qrcodeMemberID = self.MemberList.keys.sorted()[indexPath.row]
        if let qrcodeString = self.MemberList[qrcodeMemberID] {
            selectedMemberID = "\(qrcodeMemberID)"
            selectedQRImage = QRcode.make(from: qrcodeString)
            self.performSegue(withIdentifier: "qrcode", sender: self)
        } else {
            Alert.show(title: "无法找到对应的ID（MemberID:\(qrcodeMemberID)）", err: "请稍后重试", cvc: self)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? QRCodeViewController {
            dvc.qrcodeMemberID = self.selectedMemberID
            dvc.qrcodeImage = self.selectedQRImage
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
