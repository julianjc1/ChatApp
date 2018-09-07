//
//  ViewController.swift
//  wChat
//
//  Created by Julian Capeloni on 22/4/18.
//  Copyright © 2018 Julian Capeloni. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class MessageController: UITableViewController {

    var dbReference: DatabaseReference!
    var dbHandle: DatabaseHandle?
    let cellId = "cellId"
    
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        let imageMessageBar = UIImage (named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMessageBar, style: .plain, target: self, action: #selector(handleNewMessage))

        if Auth.auth().currentUser?.uid == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogIn", style: .plain, target: self, action: #selector (handleLogin))
            navigationItem.title = "NO USER FOUND :("
        }else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector (handleLogout))
            
            fetchUserAndSetupNavBarTitle()
         
            }
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        observeUserMessages()
    }
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
            let ref = Database.database().reference().child("user-messages").child(uid)
                ref.observe(.childAdded, with: {(snapshot) in
                    
                    let userId = snapshot.key
                    print(uid)
                    print(userId)
            
            let userReference = Database.database().reference().child("user-messages").child(uid).child(userId)
                userReference.observe(.childAdded, with: {(snapshot) in
        
                    let messageId = snapshot.key
                    print(messageId)

            let messagesReference = Database.database().reference().child("messages").child(messageId)
                messagesReference.observeSingleEvent(of: .value, with: {(snapshot) in

                let dictionary = snapshot.value as? [String: AnyObject]
                let message = Message(dictionary: dictionary!)

                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message

                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in

                            return (message1.timeStamp?.int32Value)! > (message2.timeStamp?.int32Value)!
                        })
                    }
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)

                },withCancel: nil)
            }, withCancel: nil)
        },withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else{
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else{
                    return
            }
            let user = Users(dictionary: dictionary)
             user.id = chatPartnerId
            self.showChatControllerForUser(user: user)

        },withCancel: nil)
    }

    
    @objc func handleNewMessage() {
       let newMessageController = NewMessageController ()
        newMessageController.messageController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleLogin (){
        let loginController = LoginController ()
        let navController = UINavigationController(rootViewController: loginController)
       present(navController, animated: true, completion: nil)    }
    
    @objc func handleLogout (){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController ()
        let navController = UINavigationController(rootViewController: loginController)
        present(navController, animated: true, completion: nil)
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
     
        if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Users(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: Users) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
    
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.isUserInteractionEnabled = true
        
        self.navigationItem.titleView = nameLabel
        
    }
    
    @objc func showChatControllerForUser(user: Users) {
    
        let chatLogController = ChatLogController (collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        chatLogController.user?.id = user.id
      
       navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
}
