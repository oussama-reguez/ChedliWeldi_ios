//
//  AboutViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 12/5/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import TagListView
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
class AboutViewController: UIViewController ,IndicatorInfoProvider{
    var idUser:String="4"
    var about:String=""
    var skills = [String]()
    @IBOutlet weak var tags: TagListView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
       
        let viewController = self.parent as! ProfileTabsViewController
        idUser = viewController.idUser
        about=viewController.about
        

     
        
       // tags.textFont = UIFont.systemFont(ofSize: 24)
        //tags.alignment = .center // possible values are .Left, .Center, and .Right
        
       
        tags.addTags(["Add", "two", "tags"])
        
        getSkills(idUser: idUser)
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var textAbout: UITextView!
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
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Resume")
    }
    
    
    
    func getSkills(idUser:String)   {
        Alamofire.request(AppDelegate.serverUrl+"skills", method: .post , parameters: ["user_id": idUser])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    
                    let error = data["error"].boolValue
                    if(error){
                        
                    }
                    else{
                        
                        let skills = data["skills"].arrayValue
                        skills.forEach{  word in
                        
                            self.skills.append(word["skill"].stringValue)
                            
                            
                        }
                       self.tags.removeAllTags()
                        self.tags.addTags(self.skills)
                        
                    }
                    
                   
                    
                }
                
                
        }
        
        
    }


}
