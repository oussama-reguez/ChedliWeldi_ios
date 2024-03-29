//
//  PrivateOfferViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 1/6/18.
//  Copyright © 2018 Esprit. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import PopupDialog

private let reuseIdentifier = "Cell"
var offerId:String?="5"


class PrivateOfferViewController: UIViewController{
    
    
    @IBAction func btnClick(_ sender: Any) {
        makeOfferPublic(idRequest: offerId!)
        
        
    }
    @IBOutlet weak var offerDuration: UILabel!
    @IBOutlet weak var offerDate: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    var offer:JSON? = nil

    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "h:mm a"
        return formatter
    }()

    

    
    func makeOfferPublic(idRequest:String)   {
        Alamofire.request(AppDelegate.serverUrl+"makeOfferPublic", method: .post , parameters: ["offer_id": idRequest ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    
                    if(data["error"].bool)!{
                       
                    
                    
                    }
                    
                    
                    
                    //sucesss
                }
                
                
        }
 }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        offerDescription.text=offer?["description"].stringValue
        var strStart = offer?["start"].stringValue
        var strEnd=offer?["end"].stringValue
          offerId=offer?["id"].stringValue
        
        
        let dateStart=formatter.date(from: strStart!)
        let dateEnd=formatter.date(from: strEnd!)
        
        
        
        strStart=formatter2.string(from: dateStart!)
        strEnd=formatter2.string(from: dateEnd!)
        
        
        
        formatter2.dateFormat="E"
        let day=formatter2.string(from: dateStart!)
        
        offerDate.text=day+" at "+strStart!+" to " + strEnd!
        
        offerDuration.text=dateEnd?.offsetFrom(date: dateStart!)

*/
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
