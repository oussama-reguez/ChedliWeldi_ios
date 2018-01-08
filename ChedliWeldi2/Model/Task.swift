//
//  Task.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 07/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import Foundation

class Task {
    var name:String?
    var desc:String?
    var from:String?
    var to:String?
    
    init( name:String, desc:String,from:String, to:String) {
        self.name = name
        self.desc = desc
        self.from = from
        self.to = to
    }
    
}
