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
                print("password validation failed")
            }

        } else {
            print("invalid email address")
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
