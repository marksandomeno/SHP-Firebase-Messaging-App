//
//  Toolbar.swift
//  SHP
//
//  Created by Mark Sandomeno on 6/15/17.
//  Copyright © 2017 SandoStudios. All rights reserved.
//
//import UIKit
//import FirebaseAuth
//import UserNotifications
//
///extension MessagesController: UIToolbarDelegate {
//
//
//
//    func setupToolBar() {
//
//        var myToolbar = UIToolbar()
//        myToolbar = UIToolbar(frame: CGRect(x: -10, y: -10 , width: view.bounds.size.width + 40, height: 40))
//        myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-25)
//
//
//        myToolbar.setBackgroundImage(UIImage(),
//                                     forToolbarPosition: .any,
//                                     barMetrics: .default)
//        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
//
//
//
//
//        let myUIBarButtonWeb: UIBarButtonItem = UIBarButtonItem(image : #imageLiteral(resourceName: "webicon"), style: .plain, target: self, action: #selector(whenClickOnBarButton(_:)))
//
//
//        let myUIBarButtonCloud: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cloud"), style: .plain, target: self, action :#selector(whenClickOnBarButton(_:)))
//
//        myUIBarButtonWeb.tag = 1
//        myUIBarButtonCloud.tag = 2
//
//        myUIBarButtonCloud.tintColor = UIColor(r: 230, g: 74, b: 25)
//
//
//
//        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
//
//        fixedSpace.width = 600
//
//        myToolbar.items = [myUIBarButtonWeb,fixedSpace, myUIBarButtonCloud]
//
//
//
//        self.navigationController?.view.addSubview(myToolbar)
//
//
//
//
//    }
//
//
//
//
//
//
//
//
//
//    @objc func whenClickOnBarButton(_ sender: UIBarButtonItem) {
//
//        switch sender.tag {
//
//        case 1:
//
//
//            if let url = URL(string: "https://shp.myschoolapp.com/app#login") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//
//        case 2:
//
//            if let url = URL(string: "https://login.microsoftonline.com") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//
//
//
//
//        default:
//            print("ERROR!!")
//
//        }
//
//    }
//
//}

