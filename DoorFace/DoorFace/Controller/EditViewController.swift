//
//  EditViewController.swift
//  DoorFace
//
//  Created by Marcin Kiliszek on 24/11/2018.
//  Copyright © 2018 Marcin Kiliszek. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var relationTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var face: Face?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add gesture recogniser for faceImageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        faceImageView.isUserInteractionEnabled = true
        faceImageView.addGestureRecognizer(tapGestureRecognizer)
        
        //If a face is passed (and therefore edited)
        if let face = face {
            navigationItem.title = face.name
            nameTextField.text = face.name
            relationTextField.text = face.relation
            faceImageView.image = face.photo
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Show the keyboard
        nameTextField.becomeFirstResponder()
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    //what happens after ImagePicker finishes picking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        faceImageView.image = image
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //Create an alert asking if the user wants to take a picture or choose if from camera roll
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
         print("camera")

        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.cameraFlashMode = .auto
        present(imagePicker, animated: true)
    }
    
    func openGallery() {
        print("gallery")
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    // MARK: - Navigation

    // Preparing for leaving the editView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        //if name or relation is nil or "" then set it to "Unknown"
        var name = nameTextField.text ?? "Unknown"
        if name.count == 0 { name = "Unknown" }
        var relation = relationTextField.text ?? "Unknown"
        if relation.count == 0 { relation = "Unknown" }
        let photo = faceImageView.image
        
        // Set the face to be passed to FaceTableViewController after the unwind segue.
        face = Face(name: name, photo: photo, relation: relation)
    }

}
