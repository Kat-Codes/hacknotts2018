//
//  Face.swift
//  DoorFace
//
//  Created by Marcin Kiliszek on 24/11/2018.
//  Copyright © 2018 Marcin Kiliszek. All rights reserved.
//

import Foundation
import UIKit

class Face {
    
    var name = ""
    var photo: UIImage?
    var relation = ""
    
    init?(name: String, photo: UIImage?, relation: String) {
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.relation = relation
        
    }
    
}
