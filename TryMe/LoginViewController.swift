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
//        postRequest(url: "https://proj-fash.herokuapp.com/api/auth/signup")
        
        let parameters = ["email": emailTextField.text!, "password": passwordTextField.text!]
        
        guard let url = URL(string: "https://proj-fash.herokuapp.com/api/auth/signup") else { return }
        var request = URLRequest(url: url)
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
                catch{
                    print(error)
                }
            }
            
            }.resume()
        
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
//        postRequest(url: "https://proj-fash.herokuapp.com/api/auth/login")
        
        let parameters = ["email": emailTextField.text!, "password": passwordTextField.text!]
        
        guard let url = URL(string: "https://proj-fash.herokuapp.com/api/auth/login") else { return }
        var request = URLRequest(url: url)
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
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                    print(json)
//                    if json[login] == success {
//
//                    }
                    
                    
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
                        
                }
                catch{
                    print(error)
                }
            }
            
            }.resume()
        
    }
//
//    func postRequest(url: String) {
//
//        let parameters = ["email": emailTextField.text!, "password": passwordTextField.text!]
//
//        guard let url = URL(string: url) else { return }
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
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                }
//                catch{
//                    print(error)
//                }
//            }
//
//            }.resume()
//    }
    
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
