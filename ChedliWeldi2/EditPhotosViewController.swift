
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

class EditPhotosViewController: UIViewController  , UIImagePickerControllerDelegate,IndicatorInfoProvider,UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource,UINavigationControllerDelegate  {
    
    var imagePicker = UIImagePickerController()
    var imagePicked = 0
    
    
    @IBAction func onClick(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicked = (sender as AnyObject).tag
            present(imagePicker, animated: true)
        }
    
    }
    var idUser:String="4"
     var photosString = [String]()
    var photosId = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var photos = [INSPhotoViewable]()

        
    
    func getPhotos() -> [INSPhotoViewable]  {
       var photos = [INSPhotoViewable]()
      
        self.photosString.forEach{ url in
            photos.append( INSPhoto(imageURL: URL(string: url), thumbnailImageURL: URL(string: url)))
            
        }
        
        
        
        return photos
    }
    
    
    var image:UIImage? = nil
    func uploadImage(userId:String){
        
        
        let myUrl = URL(string: AppDelegate.serverUrl+"uploadPhotos");
        let imageData = UIImageJPEGRepresentation(self.image!, 1)
        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        
        if(imageData==nil)  { return; }
        
        let params : Dictionary = [
            "image_path" : strBase64,
            "user_id" : userId
        ]
       
        Alamofire.request(myUrl!, method: .post , parameters: params).validate()
            .responseData { response in
                
                switch response.result {
                    
                case .success:
                    print("Validation Successful")
                    
                    // Print out reponse body
                    let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    print("**** response data = \(responseString!)")
                    
                    self.getPhotos(idUser: AppDelegate.userId)
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
        }}
    
    
    
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
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //  let viewController = self.parent as! ProfileTabsViewController
            //idUser = viewController.idUser
        getPhotos(idUser: AppDelegate.userId)

        
       
        
        
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
    
    var galleryPreview:INSPhotosViewController? = nil
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ExampleCollectionViewCell
        let currentPhoto = photos[(indexPath as NSIndexPath).row]
        galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
        galleryPreview?.overlayView = CustomOverlayView(frame: CGRect.zero)
        
        
        galleryPreview?.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? ExampleCollectionViewCell
            }
            return nil
        }
        present(galleryPreview!, animated: true, completion: nil)
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
                        
                        self.photos=[INSPhotoViewable]()
                         self.photosString=[String]()
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
      uploadImage(userId: AppDelegate.userId)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        
    }
    

}
