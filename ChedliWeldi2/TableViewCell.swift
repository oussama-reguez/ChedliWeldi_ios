//
//  TableViewCell.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/16/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import FoldingCell

class MyCell: FoldingCell {

    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
   
}
