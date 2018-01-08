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



class ScheduledBabysitterOfferViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    var offers:[JSON]? = nil

    private let reuseIdentifier = "Cell"
    var offerId:String?="5"
    
    @IBOutlet weak var offerUser: UIView!
    @IBOutlet weak var offerDate: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var imgProfil: UIImageView!
    @IBOutlet weak var offerDuration: UILabel!
 
    
   
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

    

    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        getTasks(id: offerId!)
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBOutlet weak var table: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(offers==nil){
            return 0
        }
        
        return offers!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath)
        
        let offer = offers?[indexPath.row]
        
        
        let description:UILabel =   cell.viewWithTag(102) as! (UILabel)
        
      
        description.text=offer?["detail"].stringValue
        
        /*
         
         let lbl1:UILabel =   cell.viewWithTag(101) as! (UILabel)
         
         let note:NSManagedObject=notes[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
         let lbl1:UILabel =   cell.viewWithTag(101) as! (UILabel)
         let lbl2:UILabel =   cell.viewWithTag(102) as! (UILabel)
         let img:UIImageView=cell.viewWithTag(103) as! (UIImageView)
         
         */
        
        
        return cell
        
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    func getOffer(idUser:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getOffer", method: .post , parameters: ["id_offer": idUser])
            
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
                    self.userId=offer["id_user"].stringValue
                    print("")
                    
                }
                
                
        }
        
        
    }
    var userId:String? = nil
    
    
    func getTasks(id:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getTasks", method: .post , parameters: ["id_offer": id ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        
                        return
                    }
                    
                    
                    
                    self.offers = data["tasks"].arrayValue
                    self.table.reloadData()
                    
                    print("")
                    
                }
                
                
        }

    



}
    
    
    
}
