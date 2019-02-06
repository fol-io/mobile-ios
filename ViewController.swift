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
        imagePicker.delegate = self

    }


    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    var imagePicker = UIImagePickerController()
    
    @IBAction func btnClicked() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismiss(animated: true, completion: { () -> Void in
//
//        })
//
//        imageView.image = image
//    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = pickedImage
//        }
//        
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = selectedImage
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        dismiss(animated: true, completion: nil)

    }
}



