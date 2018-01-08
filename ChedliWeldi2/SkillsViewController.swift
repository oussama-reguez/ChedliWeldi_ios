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

class SkillsViewController: UIViewController ,IndicatorInfoProvider , TagListViewDelegate{
    var idUser:String="4"
    var skills = [String]()
    @IBOutlet weak var input: UITextField!
    @IBAction func onAdd(_ sender: Any) {
        
        skills.append(input.text!)
        tags.addTag(input.text!)
        
        
        
        
    }
    @IBOutlet weak var tags: TagListView!
    @IBAction func apply(_ sender: Any) {
        
        skills=[String]()
        for tag in tags.tagViews {
            skills.append((tag.titleLabel?.text)!)
            
        }
        
        updateSkills(idUser: AppDelegate.userId, skills: skills)
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
     
        

     
        
       // tags.textFont = UIFont.systemFont(ofSize: 24)
        //tags.alignment = .center // possible values are .Left, .Center, and .Right
        
         tags.delegate = self
        tags.addTags(["Add", "two", "tags"])
        
        getSkills(idUser: AppDelegate.userId)
        // Do any additional setup after loading the view.
    }

      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        
        
        tags.removeTagView(tagView)

    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
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
                        
                        var skills = data["skills"].arrayValue
                        skills.forEach{  word in
                        
                            self.skills.append(word["skill"].stringValue)
                            
                            
                        }
                       self.tags.removeAllTags()
                        self.tags.addTags(self.skills)
                        
                       
                        self.updateSkills(idUser: AppDelegate.userId, skills: self.skills)
                        
                        
                    }
                    
                   
                    
                }
                
                
        }
        
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    func updateSkills(idUser:String,skills:[String])   {
        
    
        var data: [String: Any] = [
            "id_user": AppDelegate.userId,
            
            "skills": []
        ]
        
       
        

            // get existing items, or create new array if doesn't exist
            var existingItems =  [Any]()
        
        skills.forEach{  word in
            
                     existingItems.append(word)

            
            
        }
        
        
        
        
            // replace back into `data`
            data["skills"] = existingItems
       
        print(data)
        Alamofire.request(AppDelegate.serverUrl+"updateSkills", method: .post, parameters: data, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
        }
        
        
                }
        
        
        
        
        
        
    }
    
    



