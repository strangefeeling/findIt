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
    
    var inputsContainerView: UIView = {
    
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()

    
    @IBAction func registerTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        handleLoginRegister()
        view.addSubview(activityIndicator)
    }
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        //indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        return indicator
    }()
    
    //lazy
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .selected)
        view.addSubview(inputsContainerView)
        activityIndicator.center = view.center
        view.backgroundColor = myColor//UIColor(patternImage: patternImage!)
        handleLoginButton()
        
        if UserDefaults.standard.object(forKey: "loginEmail") != nil {
            emailTextField.text = UserDefaults.standard.object(forKey: "loginEmail") as? String
            passwordTextField.text = UserDefaults.standard.object(forKey: "password") as? String
        }
   
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 200)
        inputsContainerViewHeightAnchor?.isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 8).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        var animationimages: [UIImage] = []
        var i = 0
        while i <= 35{
            
                        let bundlePath = Bundle.main.path(forResource: "f\(i)", ofType: "png")
                        let image = UIImage(contentsOfFile: bundlePath!)
                        animationimages.append(image!)
            
            
            //animationimages.append(UIImage(named:"animation\(i)")!)
            i += 1
        }
        
        logoView.animationImages = animationimages
        
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(loginRegisterSegmentedControl)
        setupInputsContainerView()
        setupLoginRegisterSegmentedControl()
        view.addSubview(logoView)
        logoView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -10).isActive = true
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.runAnimation()
            
            self.animationTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.setImage), userInfo: nil, repeats: false)
            

        }
               NotificationCenter.default.addObserver(self, selector: #selector(LoginRegister.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginRegister.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func setImage(){
    print("cbb")
        logoView.stopAnimating()
        logoView.image = UIImage(named: "f35")
        logoView.animationImages = nil
    }
    
    func stopAnimating(){
        
       // logoView.stopAnimating()
       // animationTimer.invalidate()
        logoView.animationImages = nil
    }

    
    var animationTimer: Timer!
    
    func runAnimation(){
        logoView.animationDuration = 1.5
        logoView.animationRepeatCount = 1
        logoView.startAnimating()
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           let keyboardHeight = keyboardSize.height
            
            
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keyboardHeight)
            
        }
    }
    
    
    func keyboardWillHide(sender: NSNotification) {
        
        UIView.animate(withDuration: 0.5) {
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let logoView: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        //logo.image = UIImage(named: "animation14")
        logo.contentMode = .scaleAspectFit

        return logo
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = myColor//UIColor(patternImage: patternImage!)//myColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = myTextColor.cgColor
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        //tf.text = "abc123"
        tf.layer.borderColor = myTextColor.cgColor
        tf.delegate = self
        
        return tf
        
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = myColor//UIColor(patternImage: patternImage!)//myColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = myTextColor.cgColor
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username:"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.layer.borderColor = myTextColor.cgColor
        
        tf.delegate = self
        
        return tf
        
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = myColor//UIColor(patternImage: patternImage!)//myColor
        // automatiskai bus paselectintas register kai ijugsni appsa
        sc.selectedSegmentIndex = 1
        sc.layer.borderWidth = 1
        let borderColor = myTextColor//UIColor.white
        sc.layer.borderColor = borderColor.cgColor
        sc.tintColor = myTextColor//.white
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        return sc
    }()
    
    @objc func handleLoginRegisterChange(){
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 150 : 200
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginButton.setTitle(title, for: .normal )
        
        nameHeightAnchor?.isActive = false
        nameHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailHeightAnchor?.isActive = false
        emailHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1 / 2 : 1/3)
        emailHeightAnchor?.isActive = true
        
        passwordheightAnchor?.isActive = false
        passwordheightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1 / 2 : 1/3)
        passwordheightAnchor?.isActive = true
        
    }
    
    func handleLoginButton(){
        loginButton.backgroundColor  = myColor//UIColor(patternImage: patternImage!)//myColor
        loginButton.layer.borderWidth = 1
        let borderColor = myTextColor//UIColor.white
        loginButton.layer.borderColor = borderColor.cgColor
        loginButton.setTitle("Register", for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitleColor(myTextColor, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    lazy var loginRegisterButton : UIButton = {
        // lazy var, nes it need access to  self
        let button = UIButton(type: .system)
        button.backgroundColor  = myColor//UIColor(patternImage: patternImage!)//myColor
        button.layer.borderWidth = 1
        let borderColor = UIColor.white
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
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.stopAnimating()
                    } else{
                        print("Log in succeded")
                        // self.tabBarController.collectionView?.reloadData()
                        // self.dismiss(animated: true, completion: nil)
                        
                        //  let navController = UINavigationController(rootViewController: tabBarController)
                        DispatchQueue.main.async {
                            // self.dismiss(animated: true, completion: nil)
                            UserDefaults.standard.set(email, forKey: "loginEmail")
                            UserDefaults.standard.set(password, forKey: "password")
                            //self.stopAnimating()
                           // UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userUid")
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self.activityIndicator.stopAnimating()
//                            self.animationTimer.invalidate()
//                            self.logoView.stopAnimating()
                            self.performSegue(withIdentifier: "sss", sender: self)
//                            self.logoView.removeFromSuperview()
//                            self.dismiss(animated: true, completion: nil)
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
        if let name = nameTextField.text{
        if let email = emailTextField.text {
            let user = Userr()
            user.email = emailTextField.text
            if let password = passwordTextField.text{
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let error = error {
                        self.presentAlert(alert: error.localizedDescription)
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.stopAnimating()
                    } else{
                        
                        print("Sign up succeded")
                        if let user = user{
                            
                            //add user into the app
                            Database.database().reference().child("users").child(user.uid).child("email").setValue(email)
                            Database.database().reference().child("users").child(user.uid).child("password").setValue(password)
                            Database.database().reference().child("users").child(user.uid).child("name").setValue(name)
                            

                            DispatchQueue.main.async {
                               // UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userUid")
                                UserDefaults.standard.set(email, forKey: "loginEmail")
                                UserDefaults.standard.set(password, forKey: "password")
                                UIApplication.shared.endIgnoringInteractionEvents()
                               // self.stopAnimating()
                                self.activityIndicator.stopAnimating()
//                                self.animationTimer.invalidate()
//                                self.logoView.stopAnimating()
                                self.performSegue(withIdentifier: "sss", sender: self)
                                self.dismiss(animated: true, completion: nil)


                            }
                            
                        }
                    }
                })
            }
        }
        }
    }
    
    lazy var emailTextField: UITextField = {
        
        let tf = UITextField()
        //  tf.backgroundColor = UIColor.blue
        tf.placeholder = "Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
       // tf.text = "rytis@gmail.com"
        tf.delegate = self
        tf.layer.borderColor = myTextColor.cgColor
        
        return tf
        
        
        
    }()
    
    var user = Userr()
    
    @IBOutlet var loginButton: UIButton!
    
    var passwordheightAnchor: NSLayoutConstraint?
    
    var emailHeightAnchor: NSLayoutConstraint?
    
    var nameHeightAnchor: NSLayoutConstraint?
    
    var nameSeparatotViewHeightAnhor: NSLayoutConstraint?

    var emailTopAnchor: NSLayoutConstraint?

    
    func setupInputsContainerView(){
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        
        inputsContainerView.backgroundColor = .white
        inputsContainerView.layer.cornerRadius = 5
        let borderColor = myColor//UIColor(patternImage: patternImage!)//myColor
        inputsContainerView.layer.borderColor = borderColor.cgColor
        inputsContainerView.layer.borderWidth = 1.2
        inputsContainerView.layer.masksToBounds = true
        //loginButton.setTitle("Log In", for: .normal)
        
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1 / 3)
        nameHeightAnchor?.isActive = true
        
        
        
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        emailHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1 / 3)
        emailHeightAnchor?.isActive = true
        
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordheightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1 / 3)
        passwordheightAnchor?.isActive = true
        
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
