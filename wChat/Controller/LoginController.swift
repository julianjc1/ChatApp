//
//  LoginController.swift
//  wChat
//
//  Created by Julian Capeloni on 23/4/18.
//  Copyright © 2018 Julian Capeloni. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    //Datos de Variables
    let avatarBorder = 16
    let flagBorder = 6
    var imageAvatarSize = 180
    var imageFlagSize = 40
    
    var messagesController: MessageController?
    
    //Declarar Elementos
    let inputsContainerViewReg: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    lazy var loginRegisterSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        //sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(displayP3Red: 224/255, green: 124/255, blue: 0/255, alpha: 1)
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    @objc func handleLoginRegisterChange() {
       // let title = loginRegisterSegmentControl.titleForSegment(at:loginRegisterSegmentControl.selectedSegmentIndex);loginRegisterButton.setTitle(title, for:.normal)
        
        // Change height of inputsContainerViewReg
        if loginRegisterSegmentControl.selectedSegmentIndex == 0{
            inputsContainerViewRegHeightAnchor?.constant =  160
            textNameFieldHeightAnchor?.isActive = false
            setupLineNameSeparatorHeightAnchor?.isActive = false
            loginRegisterButton.setTitle("Log In", for:.normal)
            loginRegisterButtonHeightAnchor?.isActive = true
            textMailFieldHeightAnchor?.isActive = true
            mailSeparatorLineHeightAnchor?.isActive = true
            textPasswordFieldHeightAnchor?.isActive = true
        }else{
            inputsContainerViewRegHeightAnchor?.constant =  210
            textNameFieldHeightAnchor?.isActive = true
            setupLineNameSeparatorHeightAnchor?.isActive = true
            loginRegisterButton.setTitle("New User", for:.normal)
            loginRegisterButtonHeightAnchor?.isActive = true
            textMailFieldHeightAnchor?.isActive = true
            mailSeparatorLineHeightAnchor?.isActive = true
            textPasswordFieldHeightAnchor?.isActive = true
        }
    }
   let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 224, g: 124, b: 0)
        button.setTitle("error", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
       return button
    }()
    @objc func handleLoginRegister(){
        if loginRegisterSegmentControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
           handleRegister()
        }
    }
    @objc func handleLogin(){
        guard let email = textMailField.text else { return }
        guard let pass = textPasswordField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User loaded!")
                
                self.messagesController?.fetchUserAndSetupNavBarTitle()
                self.handleBack()
                
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    
    /*
    @objc func handleRegister() {
        
        guard let username = textNameField.text else { return }
        guard let email = textMailField.text else { return }
        guard let pass = textPasswordField.text else { return }
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://wchat-90fd0.firebaseio.com/")
        
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            if error == nil && user != nil {
              
                let userID = Auth.auth().currentUser!.uid
                let usersReferense = ref.child("users").child(userID)
                let values = ["name": username, "email": email, "password": pass]
                
                usersReferense.updateChildValues(values)
                
                print("User created!")
                self.dismiss(animated: false, completion: nil)
                
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
        }
    */
    let textNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let nameSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let textMailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Adress"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let mailSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let textPasswordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var imageProfile: UIImageView = {
        let im = UIImageView()
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageProfile)))
        im.isUserInteractionEnabled = true
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    let imageFlagProfile: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        //let userMail2 = Auth.auth().currentUser!.email
        //print(userMail2 as Any)
        
        view.backgroundColor = UIColor (r: 255, g: 255, b: 255)
        textNameField.delegate = self
        textMailField.delegate = self
        textPasswordField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    
       assignbackground()
        view.addSubview(inputsContainerViewReg)
        view.addSubview(loginRegisterSegmentControl)
        view.addSubview(loginRegisterButton)
        view.addSubview(textNameField)
        view.addSubview(nameSeparatorLine)
        view.addSubview(textMailField)
        view.addSubview(mailSeparatorLine)
        view.addSubview(textPasswordField)
        view.addSubview(imageProfile)
        view.addSubview(imageFlagProfile)
        
        
        setupLineNameSeparator()
        setupLineMailSeparator()
        setuploginRegisterButton()
        setupTextNameField()
        setupTextMailField()
        setupTextPasswordField()
        navBarIcons()
        setupImageProfile()
        setupImageFlagProfile()
        setupLoginRegisterSegmentControl()
        setupInputsContainerViewReg()

    }
    var inputsContainerViewRegHeightAnchor: NSLayoutConstraint?
    var textNameFieldHeightAnchor: NSLayoutConstraint?
    var setupLineNameSeparatorHeightAnchor: NSLayoutConstraint?
    var loginRegisterButtonHeightAnchor: NSLayoutConstraint?
    var textMailFieldHeightAnchor: NSLayoutConstraint?
    var mailSeparatorLineHeightAnchor: NSLayoutConstraint?
    var textPasswordFieldHeightAnchor: NSLayoutConstraint?

    func setupInputsContainerViewReg(){
        inputsContainerViewReg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerViewReg.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        inputsContainerViewReg.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        inputsContainerViewRegHeightAnchor = inputsContainerViewReg.heightAnchor.constraint(equalToConstant: 70)
        inputsContainerViewRegHeightAnchor?.isActive = true
    }
    func setupLoginRegisterSegmentControl(){
        loginRegisterSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentControl.topAnchor.constraint(equalTo: inputsContainerViewReg.topAnchor, constant: 20).isActive = true
        loginRegisterSegmentControl.widthAnchor.constraint(equalTo: inputsContainerViewReg.widthAnchor, constant: -30).isActive = true
        loginRegisterSegmentControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func setuploginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerViewReg.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginRegisterButtonHeightAnchor = loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerViewReg.bottomAnchor, constant: 25)
        loginRegisterButtonHeightAnchor?.isActive = false
    }
    func setupTextNameField(){
        textNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textNameField.widthAnchor.constraint(equalTo: textPasswordField.widthAnchor).isActive = true
        textNameField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textNameFieldHeightAnchor = textNameField.bottomAnchor.constraint(equalTo: nameSeparatorLine.topAnchor, constant: -10)
        textNameFieldHeightAnchor?.isActive = false
    }
    func setupLineNameSeparator(){
        nameSeparatorLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameSeparatorLine.widthAnchor.constraint(equalTo: textPasswordField.widthAnchor, constant: 5).isActive = true
        nameSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        setupLineNameSeparatorHeightAnchor = nameSeparatorLine.bottomAnchor.constraint(equalTo: textMailField.topAnchor, constant: -10)
        setupLineNameSeparatorHeightAnchor?.isActive = false
    }
    func setupTextMailField(){
        textMailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //textMailField.bottomAnchor.constraint(equalTo: mailSeparatorLine.topAnchor, constant: -10).isActive = true
        textMailField.widthAnchor.constraint(equalTo: textPasswordField.widthAnchor).isActive = true
        textMailField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textMailFieldHeightAnchor = textMailField.bottomAnchor.constraint(equalTo: mailSeparatorLine.topAnchor, constant: -10)
        textMailFieldHeightAnchor?.isActive = false
    }
    func setupLineMailSeparator(){
        mailSeparatorLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //mailSeparatorLine.bottomAnchor.constraint(equalTo: textPasswordField.topAnchor, constant: -10).isActive = true
        mailSeparatorLine.widthAnchor.constraint(equalTo: textPasswordField.widthAnchor, constant: 5).isActive = true
        mailSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        mailSeparatorLineHeightAnchor = mailSeparatorLine.bottomAnchor.constraint(equalTo: textPasswordField.topAnchor, constant: -10)
        mailSeparatorLineHeightAnchor?.isActive = false
    }
    func setupTextPasswordField(){
        textPasswordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //textPasswordField.bottomAnchor.constraint(equalTo: inputsContainerViewReg.bottomAnchor, constant: -15).isActive = true
        textPasswordField.widthAnchor.constraint(equalTo: inputsContainerViewReg.widthAnchor, constant: -50).isActive = true
        textPasswordField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textPasswordFieldHeightAnchor = textPasswordField.bottomAnchor.constraint(equalTo: inputsContainerViewReg.bottomAnchor, constant: -15)
        textPasswordFieldHeightAnchor?.isActive = false
    }
    func navBarIcons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector (handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector (handleProfile))
        }
    func setupImageProfile(){
        imageProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageProfile.bottomAnchor.constraint(equalTo: inputsContainerViewReg.topAnchor, constant: -20).isActive = true
        imageProfile.widthAnchor.constraint(equalToConstant: CGFloat(imageAvatarSize + avatarBorder)).isActive = true
        imageProfile.heightAnchor.constraint(equalToConstant: CGFloat(imageAvatarSize + avatarBorder)).isActive = true
        imageProfile.layer.cornerRadius = CGFloat((imageAvatarSize + avatarBorder) / 2)
        imageProfile.layer.borderWidth = CGFloat(avatarBorder)
        imageProfile.layer.borderColor = UIColor.white.cgColor
        imageProfile.image = UIImage(named: "Ragnar")
        imageProfile.contentMode = .scaleAspectFill
        imageProfile.clipsToBounds = true
    }
    func setupImageFlagProfile(){
        imageFlagProfile.rightAnchor.constraint(equalTo: imageProfile.rightAnchor, constant: CGFloat(-avatarBorder + flagBorder)).isActive = true
        imageFlagProfile.bottomAnchor.constraint(equalTo: imageProfile.bottomAnchor, constant: CGFloat(-avatarBorder + flagBorder)).isActive = true
        imageFlagProfile.widthAnchor.constraint(equalToConstant: CGFloat(imageFlagSize + flagBorder)).isActive = true
        imageFlagProfile.heightAnchor.constraint(equalToConstant: CGFloat(imageFlagSize + flagBorder)).isActive = true
        imageFlagProfile.layer.cornerRadius = CGFloat((imageFlagSize + flagBorder) / 2)
        imageFlagProfile.image = UIImage(named: "FrFlag")
        imageFlagProfile.layer.borderWidth = CGFloat(flagBorder)
        imageFlagProfile.layer.borderColor = UIColor.white.cgColor
        imageFlagProfile.contentMode = .scaleAspectFill
        imageFlagProfile.clipsToBounds = true
    }
    func assignbackground(){
        let background = UIImage(named: "logingBackgroundImg")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
 
        //let imageView = UIImageView(image: UIImage(named: "girlgoneabroad"))
        //imageView.frame = view.bounds
        //imageView.contentMode = .scaleToFill
       // imageView.contentMode =  UIViewContentMode.scaleAspectFill
        //let blurEffect = UIBlurEffect(style: .extraLight)
        //let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        //blurredEffectView.frame = imageView.bounds
        view.addSubview(imageView)
       // view.addSubview(blurredEffectView)
}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
   // override var preferredStatusBarStyle: UIStatusBarStyle { return . lightContent }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textNameField {
            textMailField.becomeFirstResponder()
        }else if textField == textMailField {
            textPasswordField.becomeFirstResponder()
        }else if textField == textPasswordField{
            textPasswordField.resignFirstResponder()
        }
        return true
    }

    
    @objc func handleBack (){
        let backController = MessageController ()
        let navController = UINavigationController(rootViewController: backController)
        present(navController, animated: true, completion: nil)    }
    
    @objc func handleProfile (){
        let profileController = ProfileController ()
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true, completion: nil)    }

    
    
@objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardSize.height
    }
    }
}

@objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}


extension UIColor {
    convenience init(r: CGFloat, g:CGFloat, b:CGFloat) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha:1)
    }
}


