//
//  LoginRegister.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 24/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class LoginRegister: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var inputsContainerView: UIView!
    
    var keyboardHeight: CGFloat = 0
    
    @IBAction func registerTapped(_ sender: Any) {
        handleLoginRegister()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: patternImage!)
        handleLoginButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginRegister.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginRegister.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //view.backgroundColor = myColor
        navigationController?.navigationBar.isHidden = true
        //  view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        setupInputsContainerView()
        setupLoginRegisterSegmentedControl()
        view.addSubview(logoView)
        logoView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -10).isActive = true
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            self.view.frame.origin.y -= keyboardHeight
            
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keyboardHeight)
            
        }
    }
    
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += keyboardHeight
        UIView.animate(withDuration: 0.5) {
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        setupInputsContainerView()
        setupLoginRegisterSegmentedControl()
        keyboardHeight = 0
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let logoView: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "binoculars (1)")
        return logo
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: patternImage!)//myColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.text = "abc123"
    
        tf.delegate = self
        
        return tf
        
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(patternImage: patternImage!)//myColor
        // automatiskai bus paselectintas register kai ijugsni appsa
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        return sc
    }()
    
    @objc func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginButton.setTitle(title, for: .normal )
        
    }
    
    func handleLoginButton(){
        loginButton.backgroundColor  = UIColor(patternImage: patternImage!)//myColor
        //loginButton.layer.borderWidth = 1
        // let borderColor = UIColor.darkGray
        // loginButton.layer.borderColor = borderColor.cgColor
        loginButton.setTitle("Register", for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    lazy var loginRegisterButton : UIButton = {
        // lazy var, nes it need access to  self
        let button = UIButton(type: .system)
        button.backgroundColor  = UIColor(patternImage: patternImage!)//myColor
        // button.layer.borderWidth = 1
        let borderColor = UIColor.darkGray
        //button.layer.borderColor = borderColor.cgColor
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        //add an action to a button
        // button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        } else{
            handleRegister()
        }
    }
    
    
    
    func setupLoginRegisterSegmentedControl(){
        // x,y, width, height
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func handleLogin(){
        if let email = emailTextField.text {
            user.email = emailTextField.text
            
            if let password = passwordTextField.text{
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if let error = error {
                        self.presentAlert(alert: error.localizedDescription)
                    } else{
                        
                        print("Log in succeded")
                        // self.tabBarController.collectionView?.reloadData()
                        // self.dismiss(animated: true, completion: nil)
                        
                        //  let navController = UINavigationController(rootViewController: tabBarController)
                        DispatchQueue.main.async {
                            // self.dismiss(animated: true, completion: nil)
                            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userUid")
                            self.performSegue(withIdentifier: "sss", sender: self)
                        }
                        
                        
                        //   self.viewController.collectionView?.setNeedsLayout()
                        
                    }
                })
                
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func handleRegister(){
        
        if let email = emailTextField.text {
            let user = Userr()
            user.email = emailTextField.text
            if let password = passwordTextField.text{
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let error = error {
                        self.presentAlert(alert: error.localizedDescription)
                    } else{
                        
                        print("Sign up succeded")
                        if let user = user{
                            
                            //add user into the app
                            Database.database().reference().child("users").child(user.uid).child("email").setValue(email)
                            Database.database().reference().child("users").child(user.uid).child("password").setValue(password)
                            
                            
                            let tabBarController = TabBarController()
                            DispatchQueue.main.async {
                                //     let navController = UINavigationController(rootViewController: TabBarController())
                                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userUid")
                                self.performSegue(withIdentifier: "sss", sender: self)
                                // self.present(tabBarController, animated: true, completion: nil)
                                //self.show(tabBarController, sender: nil)
                            }
                            
                        }
                    }
                })
            }
        }
        
    }
    
    lazy var emailTextField: UITextField = {
        
        let tf = UITextField()
        //  tf.backgroundColor = UIColor.blue
        tf.placeholder = "Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "rytis@gmail.com"
        tf.delegate = self
        
        return tf
        
        
        
    }()
    
    var user = Userr()
    
    @IBOutlet var loginButton: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        // setupInputsContainerView()
    }
    
    func setupInputsContainerView(){
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.backgroundColor = .white
        inputsContainerView.layer.cornerRadius = 5
        let borderColor = UIColor(patternImage: patternImage!)//myColor
        inputsContainerView.layer.borderColor = borderColor.cgColor
        inputsContainerView.layer.borderWidth = 1.2
        inputsContainerView.layer.masksToBounds = true
        //loginButton.setTitle("Log In", for: .normal)
        
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0.5).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: inputsContainerView.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0.5).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: (emailTextField.bottomAnchor)).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView .heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    
}
