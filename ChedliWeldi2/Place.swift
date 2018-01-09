//
//  Place.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 1/9/18.
//  Copyright © 2018 Esprit. All rights reserved.
//

import MapKit
import UIKit

class Place: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
