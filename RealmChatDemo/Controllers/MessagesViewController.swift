//
//  MessagesViewController.swift
//  RealmChatDemo
//
//  Created by EbitNHP-IOS on 17/08/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

class MessagesViewController: UIViewController {
    
    var objMessages = Messages()
    var objUsers = Users()
    let realm = try! Realm()
    var newUserId = Int()
    var gotUserName = String()
    var arrMsg = [Messages]()
    var keyboardHeight:CGFloat?
    var vwheight:CGFloat?
    var extraSpace:CGFloat = 0
    var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
           return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
    
    @IBOutlet weak var imgSelectedUserImage: UIImageView!
    @IBOutlet weak var lblSelectedUserName: UILabel!
    @IBOutlet weak var lblSelectedUserStatus: UILabel!
    @IBOutlet weak var tblMessages: UITableView!
    @IBOutlet var tblHeight: NSLayoutConstraint!
    
    // Chat Typeing View
    @IBOutlet var viewParentChat: UIView!
    @IBOutlet var tvChat: UITextView!
    @IBOutlet var btnSendMsg: UIButton!
    @IBOutlet var parentMsgView: UIView!
    
//MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        deRegisterKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        registerForKeyboardNotification()
    }

//MARK:- UI Setup
    func setUp() {
        
        lblSelectedUserName.text = objUsers.name
        
        tvChat.delegate = self
        
        tblMessages.delegate = self
        tblMessages.dataSource = self
        tblMessages.estimatedRowHeight = 50
        tblMessages.rowHeight = UITableView.automaticDimension
        tblMessages.register(UINib(nibName: "LeftCell", bundle: nil), forCellReuseIdentifier: "LeftCell")
        tblMessages.register(UINib(nibName: "RightCell", bundle: nil), forCellReuseIdentifier: "RightCell")
        
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.black
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.black
        }
         
        viewParentChat.layer.cornerRadius = 5
        viewParentChat.layer.masksToBounds = true
        viewParentChat.layer.borderWidth = 1
        
        let guide = view.safeAreaLayoutGuide
        vwheight = guide.layoutFrame.size.height
        extraSpace = hasTopNotch ? 30 : 0
        tblHeight.constant = vwheight! - (viewParentChat.frame.size.height + 35 + 44 + extraSpace)
        self.view.layoutIfNeeded()
        arrMsg = self.getComment()
        reloadData()
    }
    
//MARK:- UIButton
    @IBAction func clickOnSendChat(_ sender: Any) {
        tvChat.resignFirstResponder()
        if tvChat.text != "" {
            self.sendComment()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
     
}

//MARK:- UITableView Delegate and DataSource
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data:Messages = arrMsg[indexPath.row]
        
        if data.sender_id != objUsers.id {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftCell", for: indexPath) as! LeftCell
                cell.setData(model: data)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightCell", for: indexPath) as! RightCell
                cell.setData(model: data)
            return cell
        }
    }
}

//MARK:- UITextViewDelegate
extension MessagesViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

//MARK:- Keyboard Notification
extension MessagesViewController  {
    
    func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillShowNotification,
        object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification,
        object: nil)
    }
    
    func deRegisterKeyboardNotification()
    {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    @objc func keyboardWillChangeFrame(notification: NSNotification){
        
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRectValue.height
        }
        tblHeight.constant = vwheight! - (viewParentChat.frame.size.height + 35 + 44 + keyboardHeight! + extraSpace)
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardHide(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        keyboardHeight = 0;
        
        tblHeight.constant = vwheight! - (viewParentChat.frame.size.height + 35 + 44 + keyboardHeight! + extraSpace)
        self.view.layoutIfNeeded()
    }
}

//MARK:-Other Methods
extension MessagesViewController {
    
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    func sendComment() {
        self.view.endEditing(true)
        let msg = Messages()
        msg.id = msg.IncrementaID()
        msg.messageBody = tvChat.text
        msg.is_Read = "0"
        msg.time = self.generateCurrentTimeStamp()
        msg.sender_id = objUsers.id
        try! self.realm.write {
            self.realm.add(msg)
        }
        tvChat.text = ""
        arrMsg = getComment()
        reloadData()
    }
    
    func getComment() -> [Messages] {
        let arrCart = Array(realm.objects(Messages.self))
        return arrCart
    }
    
    func reloadData(){
        if arrMsg.count > 0 {
            self.tblMessages.reloadData()
        }
    }
}
