//
//  MessagesController.swift
//  SHP
//
//  Created by Mark Sandomeno on 5/2/17.
//  Copyright © 2017 Sando. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications



class MessagesController: UITableViewController {
    
    // make variables readable
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    let cellId = "cellId"
    var timer: Timer?
    var myToolbar = UIToolbar()
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
 
        let image = UIImage(named: "new_message_icon")
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                   NSAttributedStringKey.font: UIFont(name: "Avenir-Roman", size: 15)!]
    navigationController?.navigationBar.backgroundColor = UIColor.init(r: 255, g: 255, b: 255)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
         //  navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "schedule"), style: .plain, target: self, action: #selector(handleShowSchedule))
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

        checkIfUserIsLoggedIn()
        

        tableView.allowsMultipleSelectionDuringEditing = true
        
        
        //toolbar shit
        
       
        myToolbar = UIToolbar(frame: CGRect(x: -10, y: -10 , width: view.bounds.size.width + 40, height: 40))
        myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-25)
        
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        let myUIBarButtonWeb: UIBarButtonItem = UIBarButtonItem(image : #imageLiteral(resourceName: "webicon"), style: .plain, target: self, action: #selector(whenClickOnBarButton(_:)))
        
        
        let myUIBarButtonCloud: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cloud"), style: .plain, target: self, action :#selector(whenClickOnBarButton(_:)))
        
        myUIBarButtonWeb.tag = 1
        myUIBarButtonCloud.tag = 2
        
        myUIBarButtonCloud.tintColor = UIColor(r: 230, g: 74, b: 25)

        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        
        fixedSpace.width = 600
        
        myToolbar.items = [myUIBarButtonWeb,fixedSpace, myUIBarButtonCloud]
        
       
        

        self.navigationController?.view.addSubview(myToolbar)
        
      
     
       

    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            let scheduleController = daySchedule()
            let navController = UINavigationController(rootViewController: scheduleController)
            present(navController, animated: true, completion: nil)
           
        }
    }
    
  
    
  


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
  
        return true
        
       
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        guard let uid = Auth.auth().currentUser?.uid else{
            
            return
        }
        
        //know who and what we are talking about...
        let message = self.messages[indexPath.row]
        
        if let chatPartnerId = message.chatPartnerId() {
 
            fetchUserAndSetupNavBarTitle()
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    
                    print ("failed to delete message")
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.attemptReloadOfTable()
                
            })
        }
    }
    
   
    
  
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
      ref.observe(.childRemoved, with: { (snapshot) in
        
        print (snapshot.key)
        print(self.messagesDictionary)
        
        self.messagesDictionary.removeValue(forKey: snapshot.key)
        self.attemptReloadOfTable()
        
        
        
      }, withCancel: nil)
    }
    
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        
        
        let messagesReference = Database.database().reference().child("messages").child(messageId)

        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)

                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                   
                    
                }

                self.attemptReloadOfTable()
            }

        }, withCancel: nil)
    }
    
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    
    
    @objc func handleReloadTable() {
        
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
          
            
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
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
        
        return 75
        
    }
    
  
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
     
       
 
        
        
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            
            self.showChatControllerForUser(user)
            
        }, withCancel: nil)
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
            let user = User(dictionary: dictionary)

           // user.setValuesForKeys(dictionary)
            self.setupNavBarWithUser(user)
                
            }
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()

        let titleView = UIButton()
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        titleView.isUserInteractionEnabled = true
        

       
  
       
        let containerView = UIView()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.blue
       titleView.addSubview(containerView)
        
       
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "profile")

        
        self.navigationItem.titleView = titleView
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfile)))
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

    
}

    @objc func handleProfile() {
       
        let navController = UINavigationController(rootViewController: Profile())
        present(navController, animated: true) {
       
        }
        
        

    }
    
    
    @objc func whenClickOnBarButton(_ sender: UIBarButtonItem) {
        
        switch sender.tag {
        case 1:
            
                        if let url = URL(string: "https://shp.myschoolapp.com/app#login") {
                            //handleLogout()
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                           
            }
            
        case 2:
            
            if let url = URL(string: "https://login.microsoftonline.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }

        default:
            print("ERROR!!")
            
        }
        
    }
    
   
    
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
       
        navigationController?.pushViewController(chatLogController, animated: true)
        
    
       
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
    
}



fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
    
  
}






