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
import Cosmos




class PrivateOfferViewController: UIViewController{
    private let reuseIdentifier = "Cell"
    var offerId:String?="5"
    
    @IBOutlet weak var imgMessage: UIImageView!
    @IBAction func btnClick(_ sender: Any) {
        makeOfferPublic(idRequest: offerId!)
        
        
    }
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var imgProfil: UIImageView!
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
                       
                    
                    return
                    }
                    
                    //pending
                    let destination = UIStoryboard(name: "Main", bundle: nil) .
                        instantiateViewController(withIdentifier: "Requests") as? RequestsViewController
                    
                    
                    destination?.offer=self.offer
                    
                    self.navigationController?.pushViewController(destination!, animated: true)
                    
                    
                    
                    //sucesss
                }
                
                
        }
 }
    
    
    
    func getOffer(idUser:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getOffer3", method: .post , parameters: ["id_offer": idUser])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    
                    
                    
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        
                        return
                    }
                    
                    let offer = data["offer"]
                    
                    let url = URL(string: "http://localhost:8888/images/" + offer["photo"].stringValue)
                    self.imgProfil.kf.setImage(with: url)
                    self.imgProfil.makeItRound()
                    self.userId=offer["id_user"].stringValue
                    
                    self.fullName.text=(offer["firstName"].stringValue) + " " + (offer["lastName"].stringValue)
                  
                    self.rate.rating=offer["rate"].doubleValue
                    
                    print("")
                    
                }
                
                
        }
        
        
    }
    
    func tapAction(_ sender:UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "Profile") as? ProfileViewController
        
        //vc?.image=photo.image
        //vc?.fullName=name.text!
        
        let id = offer?["id_user"].stringValue
        vc?.idUser=id!
        vc?.image=imgProfil.image
        
        
        self.present(vc!, animated:true, completion:nil)
    }
    
    
    func messageAction(_ sender:UITapGestureRecognizer){
         let id = offer?["id_user"].stringValue
        
        let destination = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "chat") as? ChatViewController
        destination?.idSender=id!
        self.navigationController?.pushViewController(destination!, animated: true)
        
    }
    
    
    var userId:String? = nil    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.messageAction(_:)))
        
        imgProfil.addGestureRecognizer(gesture)
        imgMessage.addGestureRecognizer(gesture2)
        
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

          getOffer(idUser: offerId!)
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}
