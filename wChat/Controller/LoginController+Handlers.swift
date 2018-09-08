//
//  LoginController+Handlers.swift
//  wChat
//
//  Created by Julian Capeloni on 24/5/18.
//  Copyright © 2018 Julian Capeloni. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @objc func handleRegister() {
        
        //Traer datos del formulario de registro
        guard let username = textNameField.text else { return }
        guard let email = textMailField.text else { return }
        guard let pass = textPasswordField.text else { return }
        
        //Autentificar Usuario
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            if error == nil && user != nil {
                
                //Identificar Usuario
                let uid = Auth.auth().currentUser!.uid
                //Crear nombre a la imagen
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                
                //Traer la imagen cargada y reducir tamaño
                //if let profileImage = self.imageProfile.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                if let profileImage = self.imageProfile.image, let uploadData = UIImagePNGRepresentation(profileImage) {
                    //Colocar la imagen en Storage de Firabese
                     storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                        if let err = err {
                            print(err)
                        }
                        //Extraer el URL de la imagen cargada en el Storage
                        storageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print(error as Any)
                            } else {
                                guard let imageUrl = url?.absoluteString else { return }
                                let values = ["name": username, "email": email, "password": pass, "profileImageUrl": imageUrl]
                                self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    
                            }
                        })
                    }}
                //self.dismiss(animated: false, completion: nil)
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        var ref: DatabaseReference!
        ref = Database.database().reference( )
        let userID = Auth.auth().currentUser!.uid
        let usersReference = ref.child("users").child(userID)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            //self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectImageProfile() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPricker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPricker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPricker = originalImage
        }
        if let selectedImage = selectedImageFromPricker {
            imageProfile.image = selectedImage
        }
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
