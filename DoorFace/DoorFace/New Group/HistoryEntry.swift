//
//  HistoryEntry.swift
//  DoorFace
//
//  Created by Marcin Kiliszek on 24/11/2018.
//  Copyright © 2018 Marcin Kiliszek. All rights reserved.
//

import Foundation
import UIKit

class HistoryEntry {
    
    var photo : UIImage?
    var date : Date = Date();
    var messageBody : String = "Hey, somebody tried to get in!";
    var face : Face?
    
}
