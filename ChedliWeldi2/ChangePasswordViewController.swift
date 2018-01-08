//
//  ChangePasswordViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 1/8/18.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var retypePassword: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var currentPassword: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    func validatePassword(idUser:String,password:String)   {
        Alamofire.request(AppDelegate.serverUrl+"validatePassword", method: .post , parameters: ["id_user": idUser,"password":password])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    
                    
                    
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        print("incorect password")
                        return
                    }
                    
                    
                    self.changePassword(idUser: AppDelegate.userId, password: self.newPassword.text!)
                    
                    print("")
                    
                }
                
                
        }
        
        
    }
    
    @IBAction func onClick(_ sender: Any) {
        validatePassword(idUser: AppDelegate.userId, password: currentPassword.text!)
    }
    
    func changePassword(idUser:String,password:String)   {
        Alamofire.request(AppDelegate.serverUrl+"changePassword", method: .post , parameters: ["id_user": idUser ,"password":password])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    
                    
                    
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        
                        return
                    }
                    
                  
                    
                    
                    print("password changed")
                    
                }
                
                
        }
        
        
    }
    
    
    

}
