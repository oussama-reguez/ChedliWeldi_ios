//
//  BabysitterCell.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 06/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import FoldingCell
import Alamofire

class BabysitterCell: FoldingCell {
    
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBOutlet var FullName: UILabel!
    @IBAction func Call(_ sender: Any) {
        print("Called")
    }
    @IBOutlet var ProfileImg: UIImageView!
    @IBOutlet var Description: UILabel!
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
            openNumberLabel.text = String(number)
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
    
    func apply(_ image: String , name:String,descr:String) {
        
        ProfileImg.layer.cornerRadius = ProfileImg.frame.size.width/2
        ProfileImg.clipsToBounds = true
        
        Alamofire.request(AppDelegate.serverUrlTahaImage+image).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                self.ProfileImg.image = image
            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }
        
        FullName.text=name
        Description.text=descr
    }
    
    
}

// MARK: - Actions ⚡️
extension DemoCell {
    
}
