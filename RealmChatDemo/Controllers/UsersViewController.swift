//
//  ViewController.swift
//  RealmChatDemo
//
//  Created by EbitNHP-IOS on 17/08/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

import UIKit
import RealmSwift

class UsersViewController: UIViewController {

    @IBOutlet weak var tblUsers: UITableView!
    @IBOutlet weak var btnPlus: UIBarButtonItem!
    
    var users = [Users]()
    let realm = try! Realm()
    var newUserId = Int()
    var dummyMessages = [Messages]()
    var sender1Messages = [Messages]()
    var sender2Messages = [Messages]()
    var userOneUnreadCount:Int = 0
    var userTwoUnreadCount:Int = 0
    
//MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Database path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        tblUsers.delegate = self
        tblUsers.dataSource = self
        tblUsers.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        fetchUnreadMessages()
    }
    
//MARK:- UIButton
    @IBAction func addButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add User", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the user name"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let users = Users()
            let name = alertController.textFields![0] as UITextField
            users.id = users.IncrementaID()
            users.name = name.text!
            self.view.endEditing(true)
            try! self.realm.write {
                self.realm.add(users)
            }
            print("Users added successfully.")
            self.fetchUsers()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
         
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessagesViewController",
            let destination = segue.destination as? MessagesViewController
            {
                destination.gotUserName = "User1"
            }
    }
    
}

//MARK:- Tableview Delegate and DataSource
extension UsersViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.lblUserName.text = users[indexPath.row].name
        
        if users[indexPath.row].id == 1 {
            if userOneUnreadCount == 0{
                cell.lblUnreadCount.isHidden = true
                cell.lblRecentMessage.font = UIFont.italicSystemFont(ofSize: 12.0)
                cell.lblRecentMessage.text = sender1Messages.last?.messageBody
                cell.lblTime.text = RealmManager.getCmtTime(time: sender1Messages.last?.time ?? "")
            }else{
                cell.lblUnreadCount.isHidden = false
                cell.lblUnreadCount.text = String(userOneUnreadCount)
                cell.lblRecentMessage.font = UIFont.boldSystemFont(ofSize: 15.0)
                cell.lblRecentMessage.font = UIFont.italicSystemFont(ofSize: 15.0)
                cell.lblRecentMessage.text = sender1Messages.last?.messageBody
                cell.lblTime.text = RealmManager.getCmtTime(time: sender1Messages.last?.time ?? "")
            }
        } else {
            if userTwoUnreadCount == 0{
                cell.lblUnreadCount.isHidden = true
                cell.lblRecentMessage.font = UIFont.italicSystemFont(ofSize: 12.0)
                cell.lblRecentMessage.text = sender2Messages.last?.messageBody
                cell.lblTime.text = RealmManager.getCmtTime(time: sender1Messages.last?.time ?? "")
            }else{
                cell.lblUnreadCount.isHidden = false
                cell.lblUnreadCount.text = String(userTwoUnreadCount)
                cell.lblRecentMessage.text = sender2Messages.last?.messageBody
                cell.lblRecentMessage.font = UIFont.boldSystemFont(ofSize: 15.0)
                cell.lblRecentMessage.font = UIFont.italicSystemFont(ofSize: 15.0)
                cell.lblTime.text = RealmManager.getCmtTime(time: sender1Messages.last?.time ?? "")
            }
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc:MessagesViewController = storyboard.instantiateViewController(identifier: "MessagesViewController") as! MessagesViewController
        vc.objUsers = users[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK:- Other Methods
extension UsersViewController{
//MARK:- Fetch UserList
    func fetchUsers(){
        let users = realm.objects(Users.self)
        if users.count == 2 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        if users.count > 0 {
            var dumppyUsers = [Users]()
            for user in users {
                dumppyUsers.append(user)
            }
            RecordFetched(users: dumppyUsers) // Notify with records
        } else {
            RecordFetched(users: [])
        }
    }
    
    func RecordFetched(users: [Users]) {
        if users.count > 0 {
            self.users = users
            DispatchQueue.main.async {
                self.tblUsers.isHidden = false
                self.tblUsers.reloadData()
            }
        } else {
            self.tblUsers.isHidden = true
        }
    }
//MARK:- Fetch Unread Messages
    func fetchUnreadMessages(){
        userOneUnreadCount = 0
        userTwoUnreadCount = 0
        let msgs = realm.objects(Messages.self)
        if msgs.count > 0{
            for msg in msgs{
                if (msg.is_Read == "0" && msg.sender_id != 1){
                    userOneUnreadCount+=1
                }
                else if (msg.is_Read == "0" && msg.sender_id != 2){
                    userTwoUnreadCount+=1
                }
                
                if msg.sender_id != 1{
                    sender1Messages.append(msg)
                }else if msg.sender_id != 2{
                    sender2Messages.append(msg)
                }
            }
            print("Unread count \(dummyMessages)")
        }
        self.tblUsers.reloadData()
    }
}
