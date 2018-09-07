//
//  ProfileController.swift
//  wChat
//
//  Created by Julian Capeloni on 4/5/18.
//  Copyright © 2018 Julian Capeloni. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    let avatarBorder = 16
    let flagBorder = 4
    var imageAvatarSize = 176
    var imageFlagSize = 38
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 2000
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let viewProfileData: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 0
        view.layer.masksToBounds = true
        return view
    }()
    
    let profilePicture: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    let flagPicture: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    let optionArrowPicture: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    let labelAvatarName: UILabel = {
        let lb = UILabel()
        lb.text = "Ragnar Lothbrok"
        lb.textColor = .black
        lb.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let labelAvatarDescription: UILabel = {
        let lb = UILabel()
        lb.text = "King of the North - www.ragnar16.com.nor"
        lb.textColor = UIColor (r: 0, g: 0, b: 0)
        lb.font = UIFont(name: "HelveticaNeue-Thin", size: 12)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let loginFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 56, g: 168, b: 73)
        button.setTitle("Follow", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
   
        let MessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 56, g: 168, b: 73)
        button.setTitle("Message", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 9)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor (r: 255, g: 255, b: 255)
        
        view.addSubview(scrollView)
        scrollView.addSubview(viewProfileData)
        view.addSubview(profilePicture)
        view.addSubview(flagPicture)
        view.addSubview(optionArrowPicture)
        view.addSubview(MessageButton)
        view.addSubview(labelAvatarName)
        view.addSubview(labelAvatarDescription)
        view.addSubview(loginFollowButton)
        
        setupProfilePicture()
        setupFlagPicture()
        setupViewProfileData()
        setupScrollView()
        setupLabelAvatarName()
        setupLabelAvatarDescription()
        setupLoginFollowButton()
        setupOptionArrowPicture()
        setupMessageButton()
        
    }
    func setupScrollView(){
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    func setupViewProfileData(){
        viewProfileData.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        viewProfileData.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 233).isActive = true
        viewProfileData.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        viewProfileData.heightAnchor.constraint(equalToConstant: 265).isActive = true
    }
    func setupProfilePicture(){
        profilePicture.centerXAnchor.constraint(equalTo: viewProfileData.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo: viewProfileData.topAnchor, constant: 13).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: CGFloat(imageAvatarSize + avatarBorder)).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: CGFloat(imageAvatarSize + avatarBorder)).isActive = true
        profilePicture.layer.cornerRadius = CGFloat((imageAvatarSize + avatarBorder) / 2)
        profilePicture.layer.borderWidth = CGFloat(avatarBorder)
        profilePicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.image = UIImage(named: "Ragnar")
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.clipsToBounds = true
    }
    func setupFlagPicture(){
        flagPicture.rightAnchor.constraint(equalTo: profilePicture.rightAnchor, constant: CGFloat(-avatarBorder + flagBorder)).isActive = true
        flagPicture.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: CGFloat(-avatarBorder + flagBorder)).isActive = true
        flagPicture.widthAnchor.constraint(equalToConstant: CGFloat(imageFlagSize + flagBorder)).isActive = true
        flagPicture.heightAnchor.constraint(equalToConstant: CGFloat(imageFlagSize + flagBorder)).isActive = true
        flagPicture.layer.cornerRadius = CGFloat((imageFlagSize + flagBorder) / 2)
        flagPicture.image = UIImage(named: "FrFlag")
        flagPicture.layer.borderWidth = CGFloat(flagBorder)
        flagPicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.contentMode = .scaleAspectFill
        flagPicture.clipsToBounds = true
    }
    func setupOptionArrowPicture(){
        optionArrowPicture.rightAnchor.constraint(equalTo: MessageButton.leftAnchor, constant: -5).isActive = true
        optionArrowPicture.centerYAnchor.constraint(equalTo: flagPicture.centerYAnchor).isActive = true
        optionArrowPicture.widthAnchor.constraint(equalToConstant: 22).isActive = true
        optionArrowPicture.heightAnchor.constraint(equalToConstant: 21).isActive = true
        optionArrowPicture.image = UIImage(named: "ButtonOptions")
    }
    func setupMessageButton(){
        MessageButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10).isActive = true
        MessageButton.centerYAnchor.constraint(equalTo: flagPicture.centerYAnchor).isActive = true
        MessageButton.widthAnchor.constraint(equalToConstant: 67).isActive = true
        MessageButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
    }
    func setupLabelAvatarName(){
        labelAvatarName.centerXAnchor.constraint(equalTo: viewProfileData.centerXAnchor).isActive = true
        labelAvatarName.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 5).isActive = true
    }
    func setupLabelAvatarDescription(){
        labelAvatarDescription.centerXAnchor.constraint(equalTo: viewProfileData.centerXAnchor).isActive = true
        labelAvatarDescription.topAnchor.constraint(equalTo: labelAvatarName.bottomAnchor, constant: 8).isActive = true
    }
    func setupLoginFollowButton(){
        loginFollowButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginFollowButton.topAnchor.constraint(equalTo: viewProfileData.bottomAnchor, constant: 21).isActive = true
        loginFollowButton.widthAnchor.constraint(equalToConstant: 248).isActive = true
        loginFollowButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
