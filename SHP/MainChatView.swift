//
//  TableView.swift
//  SHP
//
//  Created by Mark Sandomeno on 6/16/17.
//  Copyright © 2017 SandoStudios. All rights reserved.
//

import UIKit

extension MessagesController {
    
    func setupMainChatView() {
        
        var myToolbar = UIToolbar()
        
        //Set size of toolbar
        
        myToolbar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.size.height - 35, width: view.bounds.size.width, height: 60.0))
        
        // Set position of the toolbar
        
        myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
        
        // Personalize
        
        myToolbar.tintColor = UIColor.darkGray
        
        myToolbar.backgroundColor = UIColor.white
        
        // Declare Buttons
        
        let myUIBarButtonSHPN: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "SHPN_Icon") ,style:.plain, target: self, action: #selector(whenClickOnBarButton(_:)))
        myUIBarButtonSHPN.tag = 1
        
        let myUIBarButtonSchoolNews: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "News_Icon"), style:.plain , target: self, action: #selector(whenClickOnBarButton(_:)))
        myUIBarButtonSchoolNews.tag = 2
        
        let myUIBarButtonGrades: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Grades_Icon"), style:.plain, target: self, action: #selector(whenClickOnBarButton(_:)))
        myUIBarButtonGrades.tag = 3
        
        
        let myUIBarButtonChat: UIBarButtonItem = UIBarButtonItem(image : #imageLiteral(resourceName: "Chat_Icon"), style:.plain, target: self, action: #selector(whenClickOnBarButton(_:)))
        myUIBarButtonChat.tag = 4
        
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 45.0
        
        // Flexible Space
        
        myToolbar.items = [myUIBarButtonSchoolNews,fixedSpace, myUIBarButtonSHPN,fixedSpace, myUIBarButtonChat,fixedSpace,  myUIBarButtonGrades]
        
        
        view.addSubview(myToolbar)
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: myToolbar.topAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        
        
        
    }
    
    
    
  
        
       
}
    
    
    
    
    
    
    
    
    
    

