//
//  MyOfferCollectionViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 1/6/18.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyOfferCollectionViewController: UIViewController,UICollectionViewDelegate ,UICollectionViewDataSource {

    
    @IBOutlet weak var table: UICollectionView!
    var offers:[JSON]? = nil
    var date:Date? = nil


    var formatter:DateFormatter? = nil
    var formatter2:DateFormatter? = nil
    @IBOutlet weak var test: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter = DateFormatter()
        formatter2 = DateFormatter()
        date=Date()

        formatter?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter2?.dateFormat = "dd/MM/yyyy"
    
        
        
        getOffers(id: AppDelegate.userId)
      
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if(offers==nil){
            return 0
        }
        return (offers?.count)!
    }
    
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "prototype", for: indexPath)
        
        let offer = offers?[indexPath.row]
        
        let state:UILabel =   cell.viewWithTag(101) as! (UILabel)
        
        let date :UILabel =   cell.viewWithTag(102) as! (UILabel)
        
        
        
        let strDate = offer?["start"].stringValue
        
        let d = formatter?.date(from: strDate!)
        
        
        date.text=formatter2?.string(from: d!)
       
       
        
        
        if(   offer?["id_requestedBabysitter"].isEmpty == true  ){
            
            
            state.text="private"
        }

    
        if(   offer?["id_babysitter"].isEmpty == false   ){
            

            state.text="scheduled"
        
            
        }
        
        

        
        
       
        
        
        
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let offer = offers?[indexPath.row]
        
       
        let destination = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "Requests") as? RequestsViewController
        
        
       let k = offer?["description"].stringValue
        
        
        
          destination?.offer=offer
        
        self.navigationController?.pushViewController(destination!, animated: true)
        
        
        
        
        
    }
    
    func getOffers(id:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getUserOffers", method: .post , parameters: ["id_user": id ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    self.offers = data["offers"].arrayValue
                    let k = self.offers?.count
                    self.table.reloadData()
                    
                    print("")
                    
                }
                
                
        }
        
        
        
        
    }

    
    

}
