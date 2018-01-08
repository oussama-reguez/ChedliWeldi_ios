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
import EasyNotificationBadge

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
     
        
        
        let state:UILabel =   cell.viewWithTag(102) as! (UILabel)
        
        let date :UILabel =   cell.viewWithTag(101) as! (UILabel)
        
        
        
        let strDate = offer?["start"].stringValue
        
        let start = formatter?.date(from: strDate!)

        let strDa = offer?["end"].stringValue
        
        let end = formatter?.date(from: strDa!)

        date.text=formatter2?.string(from: start!)
       
        var isEnable:Bool=false
        
        
        if(   offer?["status"].stringValue == "pending"){
            state.text="PENDING"

            isEnable=true
        }
        
        

        
        if(   offer?["status"].stringValue == "scheduled"){
            state.text="SCHEDULED"
            state.textColor=hexStringToUIColor(hex: "#f39c12")
            
        }
        
        
        if(Date().isBetweeen(date: start! , andDate: end! )){
            
            state.text="Ongoing"
            state.textColor=hexStringToUIColor(hex: "#2ecc71")
            
        }

        
        let k = offer?["requested_babysitter"].stringValue
        if( k?.isEmpty == false ){
             state.text="PRIVATE"
        }
        
        
        
        
        
        
           
        

    
        

        
        
        let view:UIView =   cell.viewWithTag(200) as! (UIView)
        
        /*
        var  badgeAppearance = BadgeAppearnce()
        badgeAppearance.backgroundColor = UIColor.blue //default is red
        badgeAppearance.textColor = UIColor.white // default is white
        badgeAppearance.textAlignment = .center //default is center
        badgeAppearance.textSize = 15 //default is 12
        badgeAppearance.distenceFromCenterX = 15 //default is 0
        badgeAppearance.distenceFromCenterY = -10 //default is 0
        badgeAppearance.allowShadow = true
        badgeAppearance.borderColor = .blue
        badgeAppearance.borderWidth = 1
 */
        
        if(isEnable){
        view.badge(text: offer?["requests"].stringValue)
        }
       
        
        
        
        
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let offer = offers?[indexPath.row]
        
        
        
        let strDate = offer?["start"].stringValue
        
        let start = formatter?.date(from: strDate!)
        
        let strDa = offer?["end"].stringValue
        
        let end = formatter?.date(from: strDa!)
        
       
        
        
        
        
        let k = offer?["requested_babysitter"].stringValue
        if( k?.isEmpty == false ){
           
            if(   offer?["status"].stringValue == "pending"){
                
                let destination = UIStoryboard(name: "Main", bundle: nil) .
                    instantiateViewController(withIdentifier: "privateOfferParent") as? PrivateOfferViewController
                
                
                destination?.offer=offer
                
                self.navigationController?.pushViewController(destination!, animated: true)
                return
                
                
                return
            }
            
            
        }
        
        
      
        
       

        
        
        
        
        
        
        if(   offer?["status"].stringValue == "pending"){
            
            //pending
            let destination = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewController(withIdentifier: "Requests") as? RequestsViewController
            
            
            destination?.offer=offer
            
            self.navigationController?.pushViewController(destination!, animated: true)
            return
        }

        
       
        
        if(   offer?["status"].stringValue == "scheduled"  &&  Date().isBetweeen(date: start! , andDate: end!)){
            
           //on going
            
            return
            
        }

        
        
        
        
        
        if(   offer?["status"].stringValue == "scheduled"){
            
          //scheduled
            let destination = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewController(withIdentifier: "scheduledParent") as? ScheduledParentOfferViewController
            
            
            
            destination?.offer=offer
            
            self.navigationController?.pushViewController(destination!, animated: true)
            return
          
        }
        
        
        
        
        
        
       
       
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    

}
