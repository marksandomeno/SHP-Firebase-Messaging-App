//
//  daySchedule.swift
//  SHP
//
//  Created by Mark Sandomeno on 2/22/18.
//  Copyright © 2018 SandoStudios. All rights reserved.
//

import UIKit


class daySchedule: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.init(r: 0, g: 52, b: 127) ,NSAttributedStringKey.font: UIFont(name: "Avenir-Roman",size: 16)!]
        
        navigationController?.navigationBar.tintColor = UIColor.init(r: 50, g: 101, b: 161)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy"
        let result = formatter.string(from: date)
       // navigationItem.title = "\(result)"
        
        self.view.backgroundColor = UIColor.init(r: 238, g: 238, b: 238)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleback))
        
        view.addSubview(scheduleImage)
        view.addSubview(SegmentedControl)
        view.addSubview(personalSchedule)
        setupScheduleImage()
        setupSegmentedControl()
        setuppersonalSchedule()
        
        
        
        
    }
    
    lazy var SegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Normal", "Mass", "Assembly"])
        
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(r: 80, g: 101, b: 161)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleChange() {
        
        if SegmentedControl.selectedSegmentIndex == 1 {
            
          scheduleImage.image = UIImage(named: "knightsofsetoniaSchedule")
       
            
        }else if SegmentedControl.selectedSegmentIndex == 2 {
            
        
           scheduleImage.image = UIImage(named: "assemblySchedule")
            
        }else {
            
            scheduleImage.image = UIImage(named: "normalSchedule")
            
        }
        
    }
    
    func setupSegmentedControl() {
        //need x, y, width, height constraints
        
        SegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        SegmentedControl.topAnchor.constraint(equalTo: scheduleImage.bottomAnchor, constant: 12).isActive = true
        //SegmentedControl.widthAnchor.constraint(equalTo: scheduleImage.widthAnchor, multiplier: 1).isActive = true
        SegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 11).isActive = true
        SegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -11).isActive = true
        SegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    let personalSchedule: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitle("Personal Schedule", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.init(r: 50, g: 101, b: 161), for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendtoSchedule), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc func sendtoSchedule() {
        
        if let url = URL(string: "https://shp.myschoolapp.com/app/student#studentmyday/schedule") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    func setuppersonalSchedule() {
        
        personalSchedule.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        personalSchedule.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        personalSchedule.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    
    
    let scheduleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "normalSchedule")
        return imageView
    }()
    
    func setupScheduleImage() {
        
        scheduleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //scheduleImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        scheduleImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        scheduleImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        scheduleImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        scheduleImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        
    }
    
   
    @objc func handleback() {
        
          dismiss(animated: true, completion: nil)
        
    }
    
 
    
    
}


