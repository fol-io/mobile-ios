//
//  ViewController.swift
//  TryMe
//
//  Created by Ruhsane Sawut on 2/4/19.
//  Copyright © 2019 ruhsane. All rights reserved.
//

import UIKit
import TCMask

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TCMaskViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    var flag = 0
    @IBOutlet var torsoImageView: ResizableView!
    @IBOutlet weak var pantImageView: ResizableView!
    @IBOutlet var chooseBuuton: UIButton!
    @IBOutlet weak var pantButto: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func editButtonClicked(_ sender: Any) {
        presentTCMaskView(image: torsoImageView.image!)
    }


    
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
                torsoImageView.image = selectedImage
            } else if flag == 2 {
                pantImageView.image = selectedImage
            }
            
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        dismiss(animated: true, completion: nil)

    }
    
    func presentTCMaskView(image: UIImage) {
        let maskView = TCMaskView(image: image)
        maskView.delegate = self
        maskView.presentFrom(rootViewController: self, animated: true)
    }
    
    func tcMaskViewDidComplete(mask: TCMask, image: UIImage) {
        let outputImage = mask.cutout(image: image, resize: true)

        torsoImageView.image = outputImage

    }


}
