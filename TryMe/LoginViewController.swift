//
//  LoginViewController.swift
//  TryMe
//
//  Created by Ruhsane Sawut on 2/19/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {

    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var LOGO: UIImageView!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    //ICONS
    @IBOutlet weak var emailIconView: UIView!
    @IBOutlet weak var emailIcon: UIImageView!
    
    @IBOutlet weak var passwordIconView: UIView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    //EMAIL STACKVIEW
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    //PASSWORD STACKVIEW
    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //BUTTONS
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!

    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        let validation = validateEmail(email: emailTextField.text ?? "")
        print(validation)
        if validation == true {
            
            let passwordValidation = passwordVlidation(password: passwordTextField.text ?? "")
            if passwordValidation == true {
                
                // call the back end sign up process . (back end gives back both if it passed back end side's validation process AND successfully or not it went through sign up process(which already takes care of going to the main screen if successful)
                postRequest(url: "https://try--me.herokuapp.com/auth/signup", callName: "signUp")
            
            } else {
                self.alert(title: "password validation failed", message: "password needs to be stronger", actionTitle: "OK")
                //TODO: BE MORE SPECIFIC FOR WHAT IS WRONG WITH PASSWORD
            }

        } else {
            self.alert(title: "Invalid email", message: "Please enter a valid email", actionTitle: "OK")
        }
    }
    
    
    @IBAction func LoginTapped(_ sender: Any) {
        postRequest(url: "https://try--me.herokuapp.com/auth/login", callName: "Login")
    }
    
    func validateEmail(email: String)  -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print( emailTest.evaluate(with: email))
        return emailTest.evaluate(with: email)
    }
    
    func passwordVlidation(password: String) -> Bool {
        let passwordRegEx = "([A-Z]+){1,}([a-z]+){1,}([0-9]+){1,}([?!@#$%^&*()_\\-+=//\\.,<>;:'\"]){1,} "
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        print( passwordTest.evaluate(with: password))
        return passwordTest.evaluate(with: password)
    }

    func postRequest(url: String, callName: String ){

        let parameters = ["email": emailTextField.text!, "password": passwordTextField.text!]

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //make our parameter a json object
        guard let httpBody =  try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }

            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print(json)
                    
                    if callName == "signUp" {
                        self.signupResponseHandler(data:data, json: json)
                        
                    } else if callName == "Login" {
                        self.LoginResponseHandler(data:data, json: json)
    
                    }
                }
                catch{
                    print(error)
                }
            }

            }.resume()
    }
    
    func signupResponseHandler(data: Data, json: [String: Any]){
        

        //handle if statusSignUpProcess successfully or not go through server side validation
    
        //handle if statusSignUpProcess didnt sign up successfully
        
        let signupMessage = json["signup"] as! String
        print("HEREEEEEEEEE!", signupMessage)
        
        if signupMessage == "success" {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
                self.present(vc, animated: true, completion: nil)
                            //TODO: SAVE THE TOKEN TO USER DEFAULT
            }
        } else if signupMessage == "fail"  {
            
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Email already in use", message: "Email you have entered has already signed up!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            
        } else {
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "Sign Up Failed", message: "Sorry. Unexpected sign up error, please try again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
            }
        
        
        }
    
    func LoginResponseHandler(data: Data, json: [String: Any]) {

    
        let loginMessage = json["login"] as! String
        
        if loginMessage == "success" {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
                self.present(vc, animated: true, completion: nil)
                //TODO: SAVE THE TOKEN TO USER DEFAULT
            }
        } else if loginMessage == "fail"  {
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Invalid username/password", message: "Invalid username/password", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Login Failed", message: "Unexpected Login Error, please try again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func alert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIDesign()
        SetupConstraints()
    
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func UIDesign() {
        //SUBVIEWS
        topStackView.addSubview(LOGO)
        bottomStackView.addSubview(emailStackView)
        bottomStackView.addSubview(passwordStackView)
        bottomStackView.addSubview(logInButton)
        bottomStackView.addSubview(signUpButton)
        view.addSubview(emailIconView)
        view.addSubview(passwordIconView)
        
        emailIconView.addSubview(emailIcon)
        passwordIconView.addSubview(passwordIcon)
        
        emailStackView.addSubview(emailLabel)
        emailStackView.addSubview(emailTextField)
        passwordStackView.addSubview(passwordLabel)
        passwordStackView.addSubview(passwordTextField)
        
        //BACKGROUND GRADIENT
        let gradient = CAGradientLayer(start: .topCenter, end: .bottomCenter, colors: [UIColor.white.cgColor, #colorLiteral(red: 0.3846877552, green: 0.57609926, blue: 0.9420570214, alpha: 1)], type: .axial)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)

        //EMAILS
        emailLabel.textColor = #colorLiteral(red: 0.2053388953, green: 0.1960159242, blue: 0.2506855726, alpha: 1)
        emailLabel.text = "EMAIL"
        emailLabel.font = UIFont(name: "AppleSDGothicNeo", size: 8.0)

        emailTextField.backgroundColor = .clear
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1)])

        //PASSWORDS
        passwordLabel.textColor = #colorLiteral(red: 0.2053388953, green: 0.1960159242, blue: 0.2506855726, alpha: 1)
        passwordLabel.text = "PASSWORD"
        passwordLabel.font = UIFont(name: "AppleSDGothicNeo", size: 8.0)
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.isSecureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1)])
        //LOGIN BUTTON
        logInButton.backgroundColor = .clear
        logInButton.layer.cornerRadius = 40
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = #colorLiteral(red: 0.2053388953, green: 0.1960159242, blue: 0.2506855726, alpha: 1)
        logInButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        logInButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
        //SIGNUP BUTTON
        signUpButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        signUpButton.setTitle("SIGN UP", for: .normal)
        
        emailIconView.backgroundColor = .clear
        passwordIconView.backgroundColor = .clear
        

    }
    
    func SetupConstraints(){

        // TOP STACK VIEW
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        topStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        //LOGO
        LOGO.translatesAutoresizingMaskIntoConstraints = false
        LOGO.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
        LOGO.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor).isActive = true
        LOGO.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor).isActive = true
        LOGO.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor).isActive = true
        
        
        // EMAIL ICON VIEW
        emailIconView.translatesAutoresizingMaskIntoConstraints = false
        emailIconView.topAnchor.constraint(equalTo: bottomStackView.topAnchor).isActive = true
        emailIconView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
        emailIcon.trailingAnchor.constraint(equalTo: emailStackView.leadingAnchor, constant: -20).isActive = true
        emailIconView.bottomAnchor.constraint(equalTo: passwordIcon.topAnchor).isActive = true
        emailIconView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        emailIconView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 1/5).isActive = true
        
        // PASSWORD ICON VIEW
        passwordIconView.translatesAutoresizingMaskIntoConstraints = false
//        passwordIconView.topAnchor.constraint(equalTo: emailIconView.bottomAnchor).isActive = true
//        passwordIconView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
//        passwordIconView.trailingAnchor.constraint(equalTo: passwordStackView.leadingAnchor).isActive = true
        passwordIconView.trailingAnchor.constraint(equalTo: passwordStackView.leadingAnchor, constant: -20).isActive = true
        passwordIconView.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -20).isActive = true
        passwordIconView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        passwordIconView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 1/5).isActive = true
        
        
        // EMAIL ICON
        emailIcon.translatesAutoresizingMaskIntoConstraints = false
//        emailIcon.topAnchor.constraint(equalTo: bottomStackView.topAnchor).isActive = true
//        emailIcon.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
//        //emailIcon.trailingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
//        emailIcon.bottomAnchor.constraint(equalTo: passwordIcon.topAnchor).isActive = true
//        emailIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        emailIcon.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 1/5).isActive = true
//        emailIcon.topAnchor.constraint(equalTo: emailIconView.topAnchor, constant: 20).isActive = true
        emailIcon.heightAnchor.constraint(equalTo: emailIconView.heightAnchor, multiplier: 1/3).isActive = true
        emailIcon.centerYAnchor.constraint(equalTo: emailIconView.centerYAnchor).isActive = true
        emailIcon.leadingAnchor.constraint(equalTo: emailIconView.leadingAnchor, constant: 10).isActive = true
        emailIcon.trailingAnchor.constraint(equalTo: emailIconView.trailingAnchor, constant: -10).isActive = true
//        emailIcon.bottomAnchor.constraint(equalTo: emailIconView.bottomAnchor, constant: -20).isActive = true
//
//        // PASSWORD ICON
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
        passwordIcon.topAnchor.constraint(equalTo: passwordIconView.topAnchor).isActive = true

        passwordIcon.heightAnchor.constraint(equalTo: passwordIconView.heightAnchor, multiplier: 1/3).isActive = true
//        passwordIcon.centerYAnchor.constraint(equalTo: passwordIconView.centerYAnchor).isActive = true

//        passwordIcon.centerXAnchor.constraint(equalTo: passwordIconView.centerXAnchor).isActive = true
        passwordIcon.leadingAnchor.constraint(equalTo: passwordIconView.leadingAnchor, constant: 10).isActive = true
//        passwordIcon.trailingAnchor.constraint(equalTo: passwordIconView.trailingAnchor, constant: -50).isActive = true
//        passwordIcon.bottomAnchor.constraint(equalTo: passwordIconView.bottomAnchor, constant: -10).isActive = true
        passwordIcon.widthAnchor.constraint(equalTo: passwordIconView.widthAnchor, multiplier: 1/2).isActive = true
        
        //BOTTOM STACK VIEW
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        //EMAIL STACKVIEW
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        emailStackView.topAnchor.constraint(equalTo: bottomStackView.topAnchor).isActive = true
        emailStackView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
        emailStackView.leadingAnchor.constraint(equalTo: emailIcon.trailingAnchor).isActive = true
        emailStackView.bottomAnchor.constraint(equalTo: passwordStackView.topAnchor).isActive = true
        emailStackView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 1/5).isActive = true
        
        //EMAIL LABEL
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: emailStackView.topAnchor).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: emailStackView.leadingAnchor).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: emailStackView.trailingAnchor).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalTo: emailStackView.heightAnchor, multiplier: 0.5).isActive = true

        
        //EMAIL TEXT FIELD
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: emailStackView.bottomAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: emailStackView.trailingAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: emailStackView.leadingAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: emailStackView.heightAnchor, multiplier: 0.5).isActive = true

        
        //PASSWORD STACKVIEW
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor).isActive = true
        passwordStackView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
        passwordStackView.leadingAnchor.constraint(equalTo: passwordIcon.trailingAnchor).isActive = true
        passwordStackView.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -20).isActive = true
        passwordStackView.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 1/5).isActive = true
        
        //PASWORD LABEL
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.topAnchor.constraint(equalTo: passwordStackView.topAnchor).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: passwordStackView.leadingAnchor).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: passwordStackView.trailingAnchor).isActive = true
        passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive = true
        passwordLabel.heightAnchor.constraint(equalTo: passwordStackView.heightAnchor, multiplier: 0.5).isActive = true

        //PASSWORD TEXT FIELD
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: passwordStackView.bottomAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: passwordStackView.trailingAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordStackView.leadingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: passwordStackView.heightAnchor, multiplier: 0.5).isActive = true


        //LOGIN BUTTON
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 15).isActive = true
        logInButton.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -15).isActive = true
        logInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20).isActive = true
        logInButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 20).isActive = true
        logInButton.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 1/5).isActive = true

        
        // SIGN UP BUTTON
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: -20).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -15).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 15).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, multiplier: 1/5).isActive = true

        
    }

}
