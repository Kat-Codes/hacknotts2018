//
//  FacesTableViewController.swift
//  DoorFace
//
//  Created by Marcin Kiliszek on 24/11/2018.
//  Copyright © 2018 Marcin Kiliszek. All rights reserved.
//

import UIKit
import Alamofire

class FacesTableViewController: UITableViewController {

    var facesArray = [Face]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let face1 = Face(name: "Peter", photo: UIImage(named: "face1"), relation: "Brother")
        let face2 = Face(name: "Joe", photo: UIImage(named: "face2"), relation: "Cousin")
        let face3 = Face(name: "Patrishia", photo: UIImage(named: "face3"), relation: "Daughter")
        
        facesArray.append(face1!)
        facesArray.append(face2!)
        facesArray.append(face3!)
        loadFace(faceImageUrl: "http://35.189.65.39/known_people/Obama.jpg", name: "Obama")
        
        tableView.register(UINib(nibName: "FaceCell", bundle: nil), forCellReuseIdentifier: "faceCell")
        tableView.rowHeight = 70
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facesArray.count
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            facesArray.remove(at: indexPath.row)
            //TODO: REMOVE IT FROM THE DATABASE
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faceCell", for: indexPath) as! FaceCell

        if let photo = facesArray[indexPath.row].photo {
            cell.faceImageView.image = photo
        }
        cell.nameLabel.text = facesArray[indexPath.row].name
        cell.relationLabel.text = facesArray[indexPath.row].relation

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editFace", sender: self)
    }
    
    
    //MARK: Navigation

    @IBAction func unwindToFaceList(sender: UIStoryboardSegue) {
        //this executes when you add/edit a face
        if let sourceViewController = sender.source as? EditViewController, let face = sourceViewController.face {
            //if an item is selected
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing face.
                facesArray[selectedIndexPath.row] = face
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new face.
                let newIndexPath = IndexPath(row: facesArray.count, section: 0)
                
                facesArray.append(face)
                postFace(faceImage: face.photo!, name: face.name)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    // Preparation before going to editing screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //making sure you're editing, not adding a new face
        if segue.identifier == "editFace" {
            guard let destination = segue.destination as? EditViewController else {
                fatalError("Error when performing the editFace segue")
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("The selected cell is not being displayed by the table")
            }
            //sending selected face to the edit screen
            destination.face = facesArray[indexPath.row]
        }
    }
    
    //MARK: Database management
    
    func loadFace(faceImageUrl : String, name : String) {
        Alamofire.request(faceImageUrl, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            // Do stuff with your image
            let httpFace = Face(name: name, photo: image, relation: "Dev")
            self.facesArray.append(httpFace!)
            self.tableView.reloadData()
        }
    }
    
    func postFace(faceImage : UIImage, name : String) {
        //TODO: post a face to the database
        let image = faceImage
        let imgData = image.jpegData(compressionQuality: 0.2)
        
        let parameters = ["name": name] //Optional for extra parameter
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "imagefile",fileName: (String)(name + ".jpg"), mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        },
                         to:"http://35.189.65.39/uploadToContacts")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    
}
