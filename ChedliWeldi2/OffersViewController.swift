//
//  OffersViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/15/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class OffersViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var table: UITableView!
    var offers:[JSON]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        getOffers()

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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(offers == nil) {
            return 0
        }
        return offers!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
        let offer = offers?[indexPath.row]
        
        
        let img:UIImageView=cell.viewWithTag(101) as! (UIImageView)
     
        let name:UILabel =   cell.viewWithTag(102) as! (UILabel)
        //let lastName:UILabel =   cell.viewWithTag(103) as! (UILabel)
        let description:UILabel =   cell.viewWithTag(104) as! (UILabel)
        
        //http://localhost:8888/images/man.png
        
        let url = URL(string: "http://localhost:8888/images/" + offer!["photo"].stringValue)
        img.kf.setImage(with: url)
           let img2:UIImageView=cell.viewWithTag(105) as! (UIImageView)
         img2.kf.setImage(with: url)
        
       // img.image=#imageLiteral(resourceName: "man")
        name.text=(offer?["firstName"].stringValue)! + " " + (offer?["lastName"].stringValue)!
       
        description.text=offer?["description"].stringValue
        

        
        /*
         
         
         let note:NSManagedObject=notes[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
         let lbl1:UILabel =   cell.viewWithTag(101) as! (UILabel)
         let lbl2:UILabel =   cell.viewWithTag(102) as! (UILabel)
         let img:UIImageView=cell.viewWithTag(103) as! (UIImageView)
         
         */
     
        
        return cell
        
    }
    func getOffers()   {
        Alamofire.request("http://localhost:8888/rest/v1/offers", method: .get)
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    self.offers = data["offers"].arrayValue
                    self.table.reloadData()
                    
                    print("")
                    
                }
                
                
        }
        
        
    }
    
    
}
