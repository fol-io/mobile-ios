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
    var CropFlag = 0
    @IBOutlet weak var lookView: UIView!
    @IBOutlet var torsoImageView: ResizableView!
    @IBOutlet weak var pantImageView: ResizableView!
    @IBOutlet var chooseBuuton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editPantButton: UIButton!
    @IBOutlet weak var mannequinView: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: lookView.bounds.size)
        let finishedLook = renderer.image { ctx in
            lookView.drawHierarchy(in: lookView.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(finishedLook, nil, nil, nil);

    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        CropFlag = 1
        guard let image = torsoImageView.image else {
            let alert = UIAlertController(title: "Torso Image is nill", message: "Please add a clothing for torso first", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        presentTCMaskView(image: image)
    }
    
    @IBAction func editPantClicked(_ sender: Any) {
        CropFlag = 2
        guard let image = pantImageView.image else {
            let alert = UIAlertController(title: "Pant Image is nill", message: "Please add a clothing for lower body first", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        presentTCMaskView(image: image)
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
        
        if CropFlag == 1 {
            torsoImageView.image = outputImage
        } else if CropFlag == 2 {
            pantImageView.image = outputImage
        }

    }
    


}
