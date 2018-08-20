//
//  ViewController.swift
//  SeeFood
//
//  Created by Junwoo Seo on 5/13/18.
//  Copyright © 2018 Junwoo Seo. All rights reserved.
//

//UIImagePickerControllerDelegate is

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var ImageView: UIImageView!

    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera//that brings up the camera functionaility
        imagePicker.allowsEditing = true
        
        
    }
    
    //the user picked the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let UserPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            

            
            guard let ciimage = CIImage(image: UserPickedImage) else{
                fatalError("could not conver to CI image")
            }
            
            detect(image: ciimage)
            ImageView.image = UserPickedImage as? UIImage

        }

        imagePicker.dismiss(animated: true, completion: nil)
        
    }


    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("could not load CoreML")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("could not access the VNClassificationObservation")
            }
            
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier
                    //self.navigationItem.title = firstResult[0]
                
                //else{
                //    self.navigationItem.title = "Not found"
                //}
            }
            print(results.first)
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
        
        
        present(imagePicker, animated: true, completion: nil) //present is to present our UIimagepickercontroller to the user
    }
    
    
}

