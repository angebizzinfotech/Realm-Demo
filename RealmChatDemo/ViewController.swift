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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
    }
    
    
}
