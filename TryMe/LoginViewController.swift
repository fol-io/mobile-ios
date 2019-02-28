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

    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
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
        
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        SetupConstraints()
        UIDesign()
    }
    
    func UIDesign() {
        //LOGIN BUTTON
        logInButton.backgroundColor = .clear
        logInButton.layer.cornerRadius = 40
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        logInButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        logInButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        
    }
    
    func SetupConstraints(){
        //LOGIN BUTTON
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 15).isActive = true
        logInButton.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -15).isActive = true
        logInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20).isActive = true
        logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive=true
        
        //STACK VIEW
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        bottomStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        bottomStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 1).isActive = true
        bottomStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1).isActive = true

        // SIGN UP BUTTON
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: -20).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -15).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 15).isActive = true
        
        //EMAIL TEXT FIELD
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: 20).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -5).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -15).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 15).isActive = true
        
        //PASSWORD TEXT FIELD
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -15).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 15).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -10).isActive = true
        
        
    }

}
