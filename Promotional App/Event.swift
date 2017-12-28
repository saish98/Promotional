//
//  Event.swift
//  Promotional App
//
//  Created by Heady on 27/12/17.
//  Copyright © 2017 Heady. All rights reserved.
//

import UIKit

class Event: NSObject {

    var name           : String?
    var small_description : String?
    
    required init(dict : [String:String]) {
        
        if let name = dict["name"] {
            self.name = name
        }else {
            self.name = ""
        }
        
        if let small_description    = dict["small_desc"] {
            self.small_description = small_description
        }else {
            self.small_description = ""
        }
    }
}
