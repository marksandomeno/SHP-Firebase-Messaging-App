//
//  Profile.swift
//  SHP
//
//  Created by Mark Sandomeno on 8/22/17.
//  Copyright © 2017 SandoStudios. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth



class Profile : UIViewController, UINavigationControllerDelegate{
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
     let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.init(r: 253, g: 253, b: 253)
      
        fetchUserForNavBar()
       
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                   NSAttributedStringKey.font: UIFont(name: "Avenir-Roman", size: 18)!]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.title = "Account"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        //SHOULD REFACTOR THIS FILE  ESP SETUPS
       
        view.addSubview(requestPasswordEmailButton)
        
        
        view.addSubview(deactivateButton)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(profileImageView)
        
        view.addSubview(editButton)
        view.addSubview(saveButton)
       
        
        
       
        setupRequestEmailButton()
        setupDeactivateButtonConstarints()
        setupnamelabel()
        setupEmailLabel()
        setupProfileImage()
        setupEditButton()
        setupSaveButton()

    }
    
    //three edit buttons
    
    let editButton: UIButton = {
        let but = UIButton()
        but.isMultipleTouchEnabled = true
        but.setImage(#imageLiteral(resourceName: "editicon"), for: .normal)
        but.addTarget(self, action: #selector(switchSaveMode), for: UIControlEvents.touchUpInside)
        
        return but
    }()
    

  
    
    @objc func switchSaveMode() {
      
       
        saveButton.backgroundColor = UIColor.green
        saveButton.setTitle("Save", for: UIControlState())
     
        emailLabel.isEnabled = true
        nameLabel.isEnabled = true
        editButton.isHidden = true
        
    }
    
    let saveButton: UIButton = {
        let but = UIButton()
        
        but.layer.cornerRadius = 22
        but.addTarget(self, action: #selector(handleSaveNewInfoToDatabase), for: UIControlEvents.touchUpInside)
        but.showsTouchWhenHighlighted = true
        return but
    }()
    
    func setupSaveButton() {
        
        saveButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -15).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func handleNewUserData() {
   
        
        
    }
   
    
    @objc func  handleSaveNewInfoToDatabase() {
        
  //needs to take email label text and name label text and selected new profile pic and update into database, and reautheticate?

       handleNewUserData()
        
        
        saveButton.backgroundColor = UIColor(r: 253, g: 253, b: 253)
        editButton.isHidden = false
        nameLabel.isEnabled = false
        emailLabel.isEnabled = false
        
     
    }
 
    
    
    func setupEditButton() {
        
     
        //editButton.bottomAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        editButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 50).isActive = true
        editButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
    
    }

    
    
    
    let deactivateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle("Deactivate", for: UIControlState())
        button.setTitleColor(UIColor.red, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleDeactivate), for: .touchUpInside)
       
 
        return button
    }()
    
    func setupDeactivateButtonConstarints()  {
        
        deactivateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        //deactivateButton.topAnchor.constraint(equalTo: requestPasswordEmailButton.bottomAnchor).isActive = true
        deactivateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deactivateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deactivateButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
   
        
        
        deactivateButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func deactivateFinal(action: UIAlertAction) {
        
        let deactivateController = DeactivateAccountPage()
        
        let navController = UINavigationController(rootViewController: deactivateController)
        present(navController, animated: false, completion: nil)
        
    }
    
    
    
    @objc func handleDeactivate() {
        
        let alertController = UIAlertController(title: "Further the deactivation process of your SHP Connect Account", message:
            "Click yes to continue", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: deactivateFinal))
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }

    var profileImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    func setupProfileImage() {
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        profileImageView.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -80).isActive = true
       profileImageView.widthAnchor.constraint(equalToConstant: 190).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
      
        
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var emailLabel: UITextField = {
        let el = UITextField()
        el.translatesAutoresizingMaskIntoConstraints = false
        el.isEnabled = false
        el.layer.cornerRadius = 22
        
        
        
        return el
    }()
    
    
    func setupEmailLabel() {
        
        emailLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -65).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
    }
    
    let nameLabel: UITextField = {
        let nl = UITextField()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.isEnabled = false
        nl.layer.cornerRadius = 18
        
        return nl
    }()
    
    func setupnamelabel() {
        nameLabel.bottomAnchor.constraint(equalTo: requestPasswordEmailButton.topAnchor, constant: -50).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -65).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
        
    }
        
    
    let requestPasswordEmailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Request Password Change", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.showsTouchWhenHighlighted = true
        button.layer.cornerRadius = 20
        
        button.addTarget(self, action: #selector(handleRequestPasswordEmail), for: .touchUpInside)
        
        return button
        
        
    }()
    
    
    
    func setupRequestEmailButton() {
        
        requestPasswordEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        requestPasswordEmailButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        requestPasswordEmailButton.bottomAnchor.constraint(equalTo: deactivateButton.topAnchor, constant: -20).isActive = true
        requestPasswordEmailButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        requestPasswordEmailButton.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
    }
    
   
    
   @objc func handleRequestPasswordEmail() {
    
    let alertController = UIAlertController(title: "Email has been sent to: " + emailLabel.text!, message:
        "", preferredStyle: UIAlertControllerStyle.alert)
      alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    
    self.present(alertController, animated: true, completion: nil)
    
    Auth.auth().sendPasswordReset(withEmail: emailLabel.text! ){ error in
        
    }
    
    print ("email has been sent to " + (emailLabel.text!))
   
        
    }
    
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    


    func fetchUserForNavBar() {
        
        //fetch current users name and displays as navbar title
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
           
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
            //fetch the users info and displays with the below code
            self.nameLabel.text = dictionary["name"] as? String
            self.emailLabel.text = dictionary["email"] as? String
            //sets profileimageurl to the image url in our user dictionary and then loads the string using extension
                if let profileImageUrl =  dictionary["profileImageUrl"] as? String {
                                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                                }
           
               


            }
            
        }, withCancel: nil)

  
    }
    

}

