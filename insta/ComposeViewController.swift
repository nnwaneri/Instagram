//
//  ComposeViewController.swift
//  insta
//
//  Created by Ellis Crawford on 10/1/18.
//  Copyright © 2018 Ellis Crawford. All rights reserved.
//

import UIKit


class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postCaptionTextView: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postCaptionTextView.textColor == UIColor.lightGray {
            postCaptionTextView.text = ""
            postCaptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postCaptionTextView.text == "" {
            postCaptionTextView.text = "Write a caption..."
            postCaptionTextView.textColor = UIColor.lightGray
        }
    }

    @IBAction func onImageTapped(_ sender: Any) {
        // Instantiate a UIImagePickerController
         let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        // Check that camera is supported on device
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera is not available 🚫. Use photo library instead.")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let editedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onShare(_ sender: Any) {
        Post.postUserImage(image: postImageView.image, withCaption: postCaptionTextView.text) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: {
                    self.postImageView.image = #imageLiteral(resourceName: "image_placeholder")
                    self.postCaptionTextView.text = "Write a caption..."
                    self.postCaptionTextView.textColor = UIColor.lightGray
                })
            } else {
                print(error?.localizedDescription ?? "Error instance was nil")
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.postImageView.image = #imageLiteral(resourceName: "image_placeholder")
            self.postCaptionTextView.text = "Write a caption..."
            self.postCaptionTextView.textColor = UIColor.lightGray
        }
    }
    
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        let resizeImageView = UIImageView(frame: rect)
        resizeImageView.contentMode = UIView.ContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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
