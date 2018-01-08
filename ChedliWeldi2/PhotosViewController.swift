
//  PhotosViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 12/2/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import INSPhotoGallery
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class PhotosViewController: UIViewController  ,IndicatorInfoProvider,UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource {
    
    var idUser:String="4"
     var photosString = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var photos = [INSPhotoViewable]()

        
    
    func getPhotos() -> [INSPhotoViewable]  {
       var photos = [INSPhotoViewable]()
      
        self.photosString.forEach{ url in
            photos.append( INSPhoto(imageURL: URL(string: url), thumbnailImageURL: URL(string: url)))
            
        }
        
        
        
        return photos
    }
    
    
    func initPhotos() -> [INSPhotoViewable]  {
       
        return [
            INSPhoto(imageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/13-3f15416ddd11d38619289335fafd498d.jpg"), thumbnailImage: UIImage(named: "thumbnailImage")!),
            INSPhoto(imageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/13-3f15416ddd11d38619289335fafd498d.jpg"), thumbnailImage: UIImage(named: "thumbnailImage")!),
            INSPhoto(image: UIImage(named: "fullSizeImage")!, thumbnailImage: UIImage(named: "thumbnailImage")!),
            INSPhoto(imageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg"), thumbnailImageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg")),
            INSPhoto(imageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg"), thumbnailImageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg")),
            INSPhoto(imageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg"), thumbnailImageURL: URL(string: "http://inspace.io/assets/portfolio/thumb/6-d793b947f57cc3df688eeb1d36b04ddb.jpg"))
            
        ]

    
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // photos=initPhotos()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
          let viewController = self.parent as! ProfileTabsViewController
            idUser = viewController.idUser
        getPhotos(idUser: idUser)

        
       
        
        
        for photo in photos {
            if let photo = photo as? INSPhoto {
                #if swift(>=4.0)
                    photo.attributedTitle = NSAttributedString(string: "Example caption text\ncaption text", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                #else
                    photo.attributedTitle = NSAttributedString(string: "Example caption text\ncaption text", attributes: [NSForegroundColorAttributeName: UIColor.white])
                #endif
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExampleCollectionViewCell", for: indexPath) as! ExampleCollectionViewCell
        cell.populateWithPhoto((photos[(indexPath as NSIndexPath).row]))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ExampleCollectionViewCell
        let currentPhoto = photos[(indexPath as NSIndexPath).row]
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
        galleryPreview.overlayView = CustomOverlayView(frame: CGRect.zero)
        
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? ExampleCollectionViewCell
            }
            return nil
        }
        present(galleryPreview, animated: true, completion: nil)
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
     return IndicatorInfo(title: "photos")
    }
    
    
    
    func getPhotos(idUser:String)   {
        Alamofire.request(AppDelegate.serverUrl+"photos", method: .post , parameters: ["user_id": idUser])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    
                    let error = data["error"].boolValue
                    if(error){
                        
                    }
                    else{
                        
                        let skills = data["photos"].arrayValue
                        skills.forEach{  word in
                            let url = AppDelegate.serverImage+word["photo"].stringValue
                            self.photosString.append(AppDelegate.serverImage+word["photo"].stringValue)
                            self.photos=self.getPhotos()
                            self.collectionView.reloadData()
                            
                            
                        }
                       
                        
                    }
                    
                    
                    
                }
                
                
        }
        
        
    }

}
