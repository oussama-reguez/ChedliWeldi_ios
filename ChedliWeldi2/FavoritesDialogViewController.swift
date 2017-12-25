//
//  RequestDialogViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/22/17.
//  Copyright © 2017 Esprit. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import Cosmos

class FavoriteDialogViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var favorites:[JSON]? = nil
    var idUser:String?="4"
   
    @IBAction func click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBOutlet weak var table: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       getFavorites(id: idUser!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(favorites==nil){
            return 0
        }
        
        return favorites!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
        
        let request = favorites?[indexPath.row]
        
        let lbl1:UILabel =   cell.viewWithTag(101) as! (UILabel)
        
        
        lbl1.text=(request?["firstName"].stringValue)! + " " + (request?["lastName"].stringValue)!
        
        let img:UIImageView=cell.viewWithTag(103) as! (UIImageView)
        
        
        let image = URL(string: AppDelegate.serverImage + request!["photo"].stringValue)
        img.kf.setImage(with: image)
        
        
        
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
    
    func getFavorites(id:String)   {
        Alamofire.request(AppDelegate.serverUrl+"favorites", method: .post , parameters: ["user_id": id ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error ){
                        
                    }
                    else{
                        
                        self.favorites = data["favorites"].arrayValue
                        self.table.reloadData()

                        
                    }
                    
                    
                    
                    
                }
                
                
        }
        
        
    }
    
    
    
    
    
       
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
