//
//  HistoryTableViewController.swift
//  DoorFace
//
//  Created by Marcin Kiliszek on 24/11/2018.
//  Copyright © 2018 Marcin Kiliszek. All rights reserved.
//

import UIKit
import AudioToolbox
import Alamofire
import AlamofireImage

class HistoryTableViewController: UITableViewController, UITabBarControllerDelegate {

    //instance variables
    var entriesArray = [HistoryEntry]()
    var timer = Timer()
    
    var cameraImage = UIImage(named: "cameraPlaceholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        //add some sample entries
        let entr1 = HistoryEntry()
        let entr2 = HistoryEntry()
        let entr3 = HistoryEntry()
        entr1.photo = UIImage(named: "sample1")
        entr1.date -= 7200
        entr2.photo = UIImage(named: "sample2")
        entr2.messageBody = "ALERT: Unrecognised face!"
        entr2.date -= 6500
        entr3.photo = UIImage(named: "sample3")
        entr3.date -= 4000
        entr3.messageBody = "Welcome home ;););)"
        entriesArray.append(entr1)
        entriesArray.append(entr2)
        entriesArray.append(entr3)
        //////////////////////////
        
        scheduledTimerWithTimeInterval()
        loadHistory()
        
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        tableView.rowHeight = 230
        tableView.separatorStyle = .none
        
        scrollToBottom(animated: false)
    }
    
    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entriesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        cell.dateLabel.text = String(self.entriesArray[indexPath.row].date.description.dropLast(6))
        cell.messageLabel.text = self.entriesArray[indexPath.row].messageBody
        if let photo = self.entriesArray[indexPath.row].photo {
            cell.doorImageView.image = photo
        }
        
        return cell
    }
    
    //MARK: - TabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            scrollToBottom(animated: true)
        }
    }
    
    //MARK: - functions
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.entriesArray.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func addNewEntry(entry : HistoryEntry) {
        entriesArray.append(entry)
        tableView.reloadData()
        scrollToBottom(animated: true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        AudioServicesPlaySystemSound(1315)
    }
    
    func loadEntry(imageUrl : String, name : String) {
        Alamofire.request(imageUrl, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                return
            }
            // Do stuff with your image
            if !self.compareImage(image1: self.cameraImage!, isEqualTo: image) {
                let httpEntry = HistoryEntry()
                httpEntry.photo = image
                httpEntry.messageBody = name + " is here!"
                self.addNewEntry(entry: httpEntry)
            }
            self.cameraImage = image
        }
    }
    
    func loadHistory() {
        //TODO: Load history
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        self.loadEntry(imageUrl: "http://35.189.65.39/Unknown_pictures/face.jpg", name: "Someone")
        Alamofire.request("http://35.189.65.39/checkIfCalling", method: .get).responseString { response in
            let result = response.result.value ?? ""
            print("‼️‼️‼️ REQUEST RESULT:")
            print(result)
            if result != "" {
                self.loadEntry(imageUrl: "http://35.189.65.39/Unknown_pictures/face.jpg", name: result)
            }
        }
    }
    
    func compareImage(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: NSData = image1.pngData()! as NSData
        let data2: NSData = image2.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
}
