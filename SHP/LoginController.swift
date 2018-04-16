//
//  LoginController.swift
//  SHP
//
//  Created by Mark Sandomeno on 5/2/17.
//  Copyright © 2017 Sando. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class LoginController: UIViewController {
    
    
    //making variables readable outside
    var messagesController: MessagesController?
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //main background color (white)
        
        view.backgroundColor = UIColor.white
        
        //dissmis keyboar on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Populating UI
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(forgotPassword)
        view.addSubview(StudentTeacherView)
        StudentTeacherView.addSubview(teacherButton)
        StudentTeacherView.addSubview(studentButton)
        StudentTeacherView.addSubview(otherButton)
        
        
        //Functions for the UI Components
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupForgotPassword()
        setupChoiceViewConstriants()
        
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    @objc func handleLoginRegister() {
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
            
            
            
        } else {
            handleRegister()
            
        }
    }
    
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error ?? "")

                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                
                self.inputsContainerView.layer.add(animation, forKey: "position")
                
                let alertController = UIAlertController(title: "Wrong Email/Password", message:
                    "Notice Passwords Are Case Sensitive", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))

                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            //successfully logged in our user
            
            if let registrationToken = Messaging.messaging().fcmToken {
                Database.database().reference().child("users").child(user!.uid).child("deviceToken").setValue(registrationToken)
            }
            else
            {
                let center = UNUserNotificationCenter.current()
                let options: UNAuthorizationOptions = [.alert, .badge, .sound]
                
                center.requestAuthorization(options: options, completionHandler: { (granted, error) in
                    if granted {
                        
                        DispatchQueue.main.async(execute: {
                            UIApplication.shared.registerForRemoteNotifications()
                            
                        })
                    }
                })
            }
        })
    }
    //handleRegister() can be found in file: LoginController+handlers
    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.99, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 22
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    lazy var forgotPassword: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Forgot Password?", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.init(r: 80, g: 101, b: 161), for: UIControlState())
        
        
        
        button.addTarget(self, action: #selector(handleForgotPasswordSwitch), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleForgotPasswordSwitch() {
        
        
        let navController = UINavigationController(rootViewController: ForgotReset())
        present(navController, animated: false, completion: nil)
        
        
    }
    
    //view that holds wht you are choice, student, teavher, other
    
    let StudentTeacherView: UIView = {
        let choiceView = UIView()
        choiceView.backgroundColor = UIColor.blue
        choiceView.layer.cornerRadius = 2
        choiceView.translatesAutoresizingMaskIntoConstraints = false
        choiceView.backgroundColor = UIColor.white
        
        return choiceView
    }()
    
    
    let teacherButton: UIButton = {
        let teacher = UIButton(type: .system)
        
        teacher.backgroundColor = UIColor(white: 0.93, alpha: 1)
        teacher.setTitle("Teacher", for: UIControlState())
        teacher.translatesAutoresizingMaskIntoConstraints = false
        teacher.setTitleColor(UIColor.white, for: UIControlState())
        teacher.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        teacher.layer.cornerRadius = 18
        
        teacher.addTarget(self, action: #selector(teacherTapped), for: .touchUpInside)
        return teacher
    }()
    
    
    @objc func teacherTapped() {
        
        teacherButton.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        studentButton.backgroundColor = UIColor(white: 0.93, alpha: 1)
        otherButton.backgroundColor = UIColor(white: 0.93, alpha: 1)
        
        profileImageView.image = UIImage(named: "teacherLogo")
        
        //profile image changed
    }
    
    
    let studentButton: UIButton = {
        let student = UIButton(type: .system)
        
        student.backgroundColor = UIColor(white: 0.93, alpha: 1)
        student.setTitle("Student", for: UIControlState())
        student.translatesAutoresizingMaskIntoConstraints = false
        student.setTitleColor(UIColor.white, for: UIControlState())
        student.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        student.layer.cornerRadius = 18
        
        student.addTarget(self, action: #selector(studentTapped), for: .touchUpInside)
        return student
    }()
    
    @objc func studentTapped() {
        
        studentButton.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        teacherButton.backgroundColor = UIColor(white: 0.93, alpha: 1)
        otherButton.backgroundColor = UIColor(white: 0.93, alpha: 1)
        
        profileImageView.image = UIImage(named: "Andrew")
    }
    
    
    let otherButton: UIButton = {
        
        let other = UIButton(type: .system)
        
        other.backgroundColor = UIColor(white: 0.93, alpha: 1)
        other.setTitle("Other", for: UIControlState())
        other.translatesAutoresizingMaskIntoConstraints = false
        other.setTitleColor(UIColor.white, for: UIControlState())
        other.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        other.layer.cornerRadius = 18
        
        other.addTarget(self, action: #selector(otherTapped), for: .touchUpInside)
        return other
    }()
    
    @objc func otherTapped() {
        
        otherButton.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        studentButton.backgroundColor = UIColor(white: 0.93, alpha: 1)
        teacherButton.backgroundColor = UIColor(white: 0.93, alpha: 1)
        
        profileImageView.image = UIImage(named: "otherLogo")
        
    }
    
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.textColor = UIColor(r: 80, g: 101, b: 161)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "SHP Email"
        tf.textColor = UIColor(r: 80, g: 101, b: 161)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password (6+ characters)"
        tf.textColor = UIColor(r: 80, g: 101, b: 161)
        tf.clearsOnBeginEditing = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Andrew")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(r: 80, g: 101, b: 161)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    @objc func handleLoginRegisterChange() {
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            
            //profileImageView.isUserInteractionEnabled = true
            passwordTextField.placeholder = "Custom Password (6+ characters)"
            
            profileImageView.image = UIImage(named: "Andrew")
            
            //show buttons
            teacherButton.isHidden = false
            teacherButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
            studentButton.isHidden = false
            studentButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
            otherButton.isHidden   = false
            otherButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
            StudentTeacherView.isHidden = false
            
            //change the constrinats to support the newly added buttons when on register VV
            
            setupChoiceViewConstriants()
            
        }else {
            
            //change text and states
            profileImageView.isUserInteractionEnabled = false
            passwordTextField.placeholder = "Password"
            profileImageView.image = UIImage(named: "Andrew")
            
            //hide buttons
            teacherButton.isHidden = true
            studentButton.isHidden = true
            otherButton.isHidden   = true
            StudentTeacherView.isHidden = true
            
        }
        
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        
        
        // change height of inputContainerView, but how???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    
    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
    }
    
    //main view that holds Student | Teacher | Other  choices
    
    
    func setupChoiceViewConstriants() {
        
        
        StudentTeacherView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        StudentTeacherView.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        StudentTeacherView.bottomAnchor.constraint(equalTo: loginRegisterButton.topAnchor, constant: -12).isActive = true
        StudentTeacherView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        StudentTeacherView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        
        teacherButton.topAnchor.constraint(equalTo:StudentTeacherView.topAnchor).isActive = true
        teacherButton.bottomAnchor.constraint(equalTo: StudentTeacherView.bottomAnchor).isActive = true
        teacherButton.leftAnchor.constraint(equalTo: StudentTeacherView.leftAnchor, constant: 2).isActive = true
        teacherButton.widthAnchor.constraint(equalTo: StudentTeacherView.widthAnchor, multiplier: 1/3).isActive = true
        
        studentButton.topAnchor.constraint(equalTo:StudentTeacherView.topAnchor).isActive = true
        studentButton.bottomAnchor.constraint(equalTo: StudentTeacherView.bottomAnchor).isActive = true
        studentButton.leftAnchor.constraint(equalTo: teacherButton.rightAnchor, constant: 2).isActive = true
        studentButton.widthAnchor.constraint(equalTo: StudentTeacherView.widthAnchor, multiplier: 1/3).isActive = true
        
        otherButton.topAnchor.constraint(equalTo:StudentTeacherView.topAnchor).isActive = true
        otherButton.bottomAnchor.constraint(equalTo: StudentTeacherView.bottomAnchor).isActive = true
        otherButton.leftAnchor.constraint(equalTo: studentButton.rightAnchor, constant: 2).isActive = true
        otherButton.widthAnchor.constraint(equalTo: StudentTeacherView.widthAnchor, multiplier: 1/3).isActive = true
        
    }
    
    
    func setupForgotPassword() {
        
        forgotPassword.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor, constant: 15).isActive = true
        forgotPassword.heightAnchor.constraint(equalToConstant: 30).isActive = true
        forgotPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPassword.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 10).isActive = true
        
    }
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //need x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        
        emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: StudentTeacherView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
}//class ends
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

