//
//  ExampleCollectionViewCell.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 12/2/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import INSPhotoGallery

class ExampleCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var imageView: UIImageView!
    
    func populateWithPhoto(_ photo: INSPhotoViewable) {
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.imageView.image = image
            }
        }
    }
}
