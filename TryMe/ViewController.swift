//
//  ViewController.swift
//  TryMe
//
//  Created by Ruhsane Sawut on 2/4/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    var flag = 0
    @IBOutlet var torsoImageView: UIImageView!
    @IBOutlet weak var pantImageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    @IBOutlet weak var pantButto: UIImageView!
    
    var imagePicker = UIImagePickerController()

    @IBAction func pantBtnClicked(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            flag = 2
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true) {
                
            }
        }
    }
    
    @IBAction func btnClicked() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            flag = 1
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true) {
                
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            
            if flag == 1 {
//                imageView.contentMode = .scaleAspectFill
                torsoImageView.image = selectedImage
            } else if flag == 2 {
//                pantImageView.contentMode = .scaleAspectFill
                
                pantImageView.image = selectedImage
            }
            
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        dismiss(animated: true, completion: nil)

    }


}
