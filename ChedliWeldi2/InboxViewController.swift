//
//  TestingViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/16/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import FoldingCell
import Alamofire
import SwiftyJSON
import Kingfisher


class InboxViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var table: UITableView!
    

    var users:[JSON]? = nil
 
  
    override func viewDidLoad() {
        super.viewDidLoad()
 
        getInbox(id: "4")
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(users == nil) {
            return 0
        }
        return users!.count
    }
    
    
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath)
    
    
    let user = users?[indexPath.row]
    let img:UIImageView=cell.viewWithTag(101) as! (UIImageView)
    let name:UILabel =   cell.viewWithTag(102) as! (UILabel)
    let date:UILabel =   cell.viewWithTag(104) as! (UILabel)
        //let lastName:UILabel =   cell.viewWithTag(103) as! (UILabel)
    let message:UILabel =   cell.viewWithTag(103) as! (UILabel)
    
    //http://localhost:8888/images/man.png
    
    let url = URL(string: AppDelegate.serverImage + user!["photo"].stringValue)
    img.kf.setImage(with: url)
    // img.image=#imageLiteral(resourceName: "man")
    name.text=(user?["firstName"].stringValue)! + " " + (user?["lastName"].stringValue)!
    message.text=user?["lastMessage"].stringValue
    date.text=user?["date"].stringValue
    

    
    
    
    
    
    
    
        return cell
    }
    
    var selectedCell:FoldingCell? = nil
    var selectedRow:Int = 0
    var selectedOffer:JSON? = nil
    
    
    
    func getInbox(id:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getInbox", method: .post,parameters: ["id_user": id ])
            
            .responseJSON { response in
          //      print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    self.users = data["users"].arrayValue
                    self.table.reloadData()
                    
                   
                    
                }
                
                
        }
        
        
    }
    

    

}
