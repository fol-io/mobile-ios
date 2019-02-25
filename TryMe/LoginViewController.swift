//
//  LoginViewController.swift
//  TryMe
//
//  Created by Ruhsane Sawut on 2/19/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        let validation = validateEmail(email: emailTextField.text ?? "")
        if validation == true {
            // call the back end sign up process . (back end gives back both if it passed back end side's validation process AND successfully or not it went through sign up process(which already takes care of going to the main screen if successful)
            
            let statusSignUpProcess = postRequest(url: "https://proj-fash.herokuapp.com/api/auth/signup", callName: "signUp")

        }
 
//
//        let parameters = ["email": emailTextField.text!, "password": passwordTextField.text!]
//
//        guard let url = URL(string: "https://proj-fash.herokuapp.com/api/auth/signup") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        //make our parameter a json object
//        guard let httpBody =  try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
//        request.httpBody = httpBody
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
//
//            if let data = data {
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                    print(json)
//                    let signupMessage = json["signup"] as! String
//                    print("HEREEEEEEEEE!", signupMessage)
//                    if signupMessage == "success" {
//                        DispatchQueue.main.async {
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
//                            self.present(vc, animated: true, completion: nil)
//                            //TODO: SAVE THE TOKEN TO USER DEFAULT
//                        }
//                    } else if signupMessage == "fail"  {
//
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "Email already in use", message: "Email you have entered has already signed up!", preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//
//                    } else {
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "Sign Up Failed", message: "Sorry. Unexpected sign up error, please try again", preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//                catch{
//                    print(error)
//                }
//            }
//
//            }.resume()
//
//    }
        }
    
    
    @IBAction func LoginTapped(_ sender: Any) {
        let statusLoginProcess = postRequest(url: "https://proj-fash.herokuapp.com/api/auth/login")
        if statusLoginProcess == true {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                print(json)
                
                if json["login"] == "success" {
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
                        self.present(vc, animated: true, completion: nil)
                        //TODO: SAVE THE TOKEN TO USER DEFAULT
                    }
                } else if json["login"] == "fail"  {
                    
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
                
            } else if statusLoginProcess == false{
                return
    }
        
//        let parameters = ["email": emailTextField.text!, "password": passwordTextField.text!]
//
//        guard let url = URL(string: "https://proj-fash.herokuapp.com/api/auth/login") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        //make our parameter a json object
//        guard let httpBody =  try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
//        request.httpBody = httpBody
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
//
//            if let data = data {
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
//                    print(json)
//
//                    if json["login"] == "success" {
//                        DispatchQueue.main.async {
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
//                            self.present(vc, animated: true, completion: nil)
//                            //TODO: SAVE THE TOKEN TO USER DEFAULT
//                        }
//                    } else if json["login"] == "fail"  {
//
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "Invalid username/password", message: "Invalid username/password", preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//
//                    } else {
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "Login Failed", message: "Unexpected Login Error, please try again", preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//
//                }
//                catch{
//                    print(error)
//                }
//            }
//
//            }.resume()
//
    }
    
    func validateEmail(email: String)  -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    return true
                }
                catch{
                    print(error)
                    return false
                }
            }

            }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
