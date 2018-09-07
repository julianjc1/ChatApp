//
//  ChatLogController.swift
//  wChat
//
//  Created by Julian Capeloni on 20/6/18.
//  Copyright © 2018 Julian Capeloni. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
   
    var user: Users? {
        didSet {
            navigationItem.title = user?.name
            observeMessage()
        }
    }
    
    var messages = [Message]()
    
    func observeMessage() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userIdChat = user?.id else { return }
        
//        Estos son los cambios que hacen saltar un error
//        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(userIdChat)
        
        userMessagesRef.observe(.childAdded, with: {(snapshot) in

            let messageId = snapshot.key
            
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: {(snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else{
                    return
                }
                let message = Message(dictionary: dictionary)
                
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
      
    }
    
    let inputTextField: UITextField = {
        let tf = UITextField ()
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
   
    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
        //setupInputComponents()
        //setupKeyboardObservers()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    
    func setupKeyboardObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!){
            self.view.layoutIfNeeded()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 32
            return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
       
        if let profileImageUrl = self.user?.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid{
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
            cell.profileImageView.isHidden = true
        }else {
            //incoming grey
            cell.bubbleView.backgroundColor = ChatMessageCell.greyColor
            cell.textView.textColor = UIColor.black
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages [indexPath.item].text {
            height = estimatedFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimatedFrameForText (text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents (){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor) .isActive = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor) .isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50) .isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for:.normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor) .isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor) .isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80) .isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor) .isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8) .isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor) .isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor) .isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor) .isActive = true
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor) .isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor) .isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor) .isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1) .isActive = true
       /*
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor) .isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor) .isActive = true
        collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor) .isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: containerView.topAnchor) .isActive = true
        */
    }
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        print("mensaje enviado")
        print(toId)
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = NSDate().timeIntervalSince1970
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timeStamp": timestamp] as [String : Any]
        childRef.updateChildValues(values)
        
        self.inputTextField.text = nil
        
        let messageId = childRef.key
/*
 //         Este es el antiguo codigo por las dudas que se rompa
 
        let userMessageRef = Database.database().reference().child("user-messages").child(fromId)
        userMessageRef.updateChildValues([messageId: 1])
        
        let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toId)
        recipientUserMessageRef.updateChildValues([messageId: 1])
 */
//         Estos son los cambios que hacen saltar un error
         
        let userMessageRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
        userMessageRef.updateChildValues([messageId: 1])

        let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
        recipientUserMessageRef.updateChildValues([messageId: 1])
        
    }
}
