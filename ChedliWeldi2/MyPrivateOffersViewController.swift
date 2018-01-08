//
//  MyOffersViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/21/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyOffersViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    var offers:[JSON]? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getOffers(id: AppDelegate.userId)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
        
        let offer = offers?[indexPath.row]
        
     let lbl1:UILabel =   cell.viewWithTag(101) as! (UILabel)
        let description:UILabel =   cell.viewWithTag(102) as! (UILabel)
        
        lbl1.text="Offer " + (offer?["id"].stringValue)!
        description.text=offer?["description"].stringValue
        
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
    
    func getOffers(id:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getPrivateOffers", method: .post , parameters: ["user_id": id ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    self.offers = data.arrayValue
                    self.table.reloadData()
                    
                    print("")
                    
                }
                
                
        }
        
    
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entitiy =  offers?[indexPath.row]
        let destination = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "Requests") as? RequestsViewController
        destination?.offerId=entitiy?["id"].stringValue
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    
    

}
