//
//  RoundImage.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 1/8/18.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit

extension UIImageView {
    
    
 func makeItRound() {
    layer.cornerRadius = frame.size.width / 2
    clipsToBounds = true
    }
    
    
    
    
    
}
