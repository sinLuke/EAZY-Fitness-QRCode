//
//  MemberTableViewController.swift
//  EAZY Fitness QRCode
//
//  Created by Luke on 2018-07-19.
//  Copyright © 2018 Mike Chan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MemberTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var MemberList : [Int:String] = [:]
    
    var filteredMemberList : [Int:String] = [:]
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedMemberID: String?
    var selectedQRImage: UIImage?
    
    let _refreshControl = UIRefreshControl()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        addRefresh()
        refresh()
        searchSetup()
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
        if isFiltering() {
            return self.filteredMemberList.count
        }
        return self.MemberList.count
    }
    
    func addRefresh(){
        let title = NSLocalizedString("下拉刷新", comment: "下拉刷新")
        _refreshControl.attributedTitle = NSAttributedString(string: title)
        _refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                  for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self._refreshControl)
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
                    if let MemberID = docs.data()["MemberID"] as? Int{
                        if self.MemberList[MemberID] == nil {
                            self.MemberList[MemberID] = docs.documentID
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if isFiltering(){
            let qrcodeMemberID = self.filteredMemberList.keys.sorted()[indexPath.row]
            cell.detailTextLabel?.text = self.filteredMemberList[qrcodeMemberID]
            cell.detailTextLabel?.textColor = UIColor.gray
            cell.textLabel?.text = "\(qrcodeMemberID)"
            return cell
        } else {
            let qrcodeMemberID = self.MemberList.keys.sorted()[indexPath.row]
            cell.detailTextLabel?.text = self.MemberList[qrcodeMemberID]
            cell.detailTextLabel?.textColor = UIColor.gray
            cell.textLabel?.text = "\(qrcodeMemberID)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering(){
            let qrcodeMemberID = self.filteredMemberList.keys.sorted()[indexPath.row]
            if let qrcodeString = self.filteredMemberList[qrcodeMemberID] {
                selectedMemberID = "\(qrcodeMemberID)"
                selectedQRImage = QRcode.make(from: qrcodeString)
                self.performSegue(withIdentifier: "qrcode", sender: self)
            } else {
                Alert.show(title: "无法找到对应的ID（MemberID:\(qrcodeMemberID)）", err: "请稍后重试", cvc: self)
            }
        } else {
            let qrcodeMemberID = self.MemberList.keys.sorted()[indexPath.row]
            if let qrcodeString = self.MemberList[qrcodeMemberID] {
                selectedMemberID = "\(qrcodeMemberID)"
                selectedQRImage = QRcode.make(from: qrcodeString)
                self.performSegue(withIdentifier: "qrcode", sender: self)
            } else {
                Alert.show(title: "无法找到对应的ID（MemberID:\(qrcodeMemberID)）", err: "请稍后重试", cvc: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? QRCodeViewController {
            dvc.qrcodeMemberID = self.selectedMemberID
            dvc.qrcodeImage = self.selectedQRImage
        }
    }
    
    func searchSetup(){
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // MARK: - Private instance methods
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

extension MemberTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMemberList = MemberList.filter({ (key: Int, value: String) -> Bool in
            let keyString = "\(key)"
            return keyString.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
