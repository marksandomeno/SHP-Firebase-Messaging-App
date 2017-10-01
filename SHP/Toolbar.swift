//
//  Toolbar.swift
//  SHP
//
//  Created by Mark Sandomeno on 6/15/17.
//  Copyright © 2017 SandoStudios. All rights reserved.
//

import UIKit


extension MessagesController: UIToolbarDelegate {
    

   func setupToolBar() {
    
    var myToolbar = UIToolbar()
    
    myToolbar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.size.height - 35, width: view.bounds.size.width, height: 46.5))
    myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-5)
    myToolbar.backgroundColor = UIColor.clear
   

        let myUIBarButtonSHPN: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sportsicon") ,style:.plain, target: self, action: #selector(whenClickOnBarButton(_:)))

        myUIBarButtonSHPN.tag = 1
        myUIBarButtonSHPN.tintColor = UIColor.init(r: 100, g: 100, b: 100)
    
        
        let myUIBarButtonSchoolNews: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "newsicon"), style:.plain , target: self, action: #selector(whenClickOnBarButton(_:)))
    
        myUIBarButtonSchoolNews.tag = 2
        myUIBarButtonSchoolNews.tintColor = UIColor.init(r: 100, g: 100, b: 100)
    
        let myUIBarButtonGrades: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "schoolicon"), style:.plain, target: self, action: #selector(whenClickOnBarButton(_:)))
        myUIBarButtonGrades.tag = 3
        myUIBarButtonGrades.tintColor = UIColor.init(r: 100, g: 100, b: 100)
    
        let myUIBarButtonWeb: UIBarButtonItem = UIBarButtonItem(image : #imageLiteral(resourceName: "webicon"), style:.plain, target: self, action: #selector(whenClickOnBarButton(_:)))
        myUIBarButtonWeb.tag = 4
        myUIBarButtonWeb.tintColor = UIColor.init(r: 100, g: 100, b: 100)
    
    
    
    
        
        
        
        
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 58.0
        
        myToolbar.items = [myUIBarButtonSchoolNews,fixedSpace, myUIBarButtonSHPN,fixedSpace, myUIBarButtonWeb,fixedSpace,  myUIBarButtonGrades]
        
        
        self.navigationController?.view.addSubview(myToolbar)

    
    }

    

   
    

    
    func whenClickOnBarButton(_ sender: UIBarButtonItem) {
        
        switch sender.tag {
            
        case 1:
            print ("switched to SHPN")
             let myUIBarButtonSHPN: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sportsicon") ,style:.plain, target: self, action: #selector(whenClickOnBarButton(_:)))
        case 2:
            break
        case 3:
            break
        case 4:
            UIApplication.shared.openURL(NSURL(string: "https://shp.myschoolapp.com/app#login")! as URL)
        default:
            print("ERROR!!")
     
        }

    }

}


