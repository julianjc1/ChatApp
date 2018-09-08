//
//  NewMessageController.swift
//  wChat
//
//  Created by Julian Capeloni on 23/5/18.
//  Copyright © 2018 Julian Capeloni. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [Users]()
    
    var dbReference: DatabaseReference!
    var dbHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector (handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUsers()
    }
    
    @objc func fetchUsers() {
        dbReference = Database.database().reference()
        dbReference.child("users").observe(.childAdded, with: { (snapshot) in
      
            let dictionary = snapshot.value as? [String: AnyObject]
            
            let user = Users(dictionary: dictionary!)
            user.id = snapshot.key
            self.users.append(user)
            DispatchQueue.main.async {
            
            //dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            }
            
            
        
        }, withCancel: nil)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
    
    var messageController: MessageController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messageController?.showChatControllerForUser(user: user)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

