//
//  CreateProfileViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/15/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import DatePickerDialog
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
//import EGFormValidator

//class CreateProfileViewController: ValidatorViewController ,UITextFieldDelegate {
    class CreateProfileViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var txtBirthDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    
    
    var email:String?=nil
    var password:String?=nil
    var type:Int?=0
    
    @IBAction func click(_ sender: Any) {
      
      /*
        
        if self.validate(){
            
            
            register(email: email!,password: password!,phoneNumber: Int(txtPhoneNumber.text!)!,firstName: txtFirstName.text!,lastName: txtLastName.text!,adress: "not yet",birthDate: txtBirthDate.text!,type: type!)
            
        }
 */
        
         register(email: email!,password: password!,phoneNumber: Int(txtPhoneNumber.text!)!,firstName: txtFirstName.text!,lastName: txtLastName.text!,adress: "not yet",birthDate: txtBirthDate.text!,type: type!)
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtBirthDate.delegate=self
      /*
        self.addValidatorMandatory(toControl: txtFirstName,
                                   errorPlaceholder: txtFirstName,
                                   errorMessage: "REQUIRED")
        
        self.addValidatorMandatory(toControl: txtLastName,
                                   errorPlaceholder: txtLastName,
                                   errorMessage: "REQUIRED")
        
        self.addValidatorMandatory(toControl: txtBirthDate,
                                   errorPlaceholder: txtBirthDate,
                                   errorMessage: "BIRTHDAY IS REQUIRED")
        
        self.addValidatorMandatory(toControl: txtPhoneNumber,
                                   errorPlaceholder: txtPhoneNumber,
                                   errorMessage: "PHONE NUMBER IS REQUIRED")

        self.addValidatorDigitsOnly(toControl: txtPhoneNumber,
                                   errorPlaceholder: txtPhoneNumber,
                                   errorMessage: "PHONE NUMBER IS NOT VALID")

        
        self.addValidatorMinLength(toControl: txtPhoneNumber,
                                   errorPlaceholder:txtPhoneNumber,
                                   errorMessage: "PHONE NUMBER IS NOT VALID",
                                   minLength: 8)
*/
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func register(email:String,password:String,phoneNumber:Int,firstName:String,lastName:String,adress:String,birthDate:String,type:Int)   {
        
        Alamofire.request( AppDelegate.serverUrl + "register", method: .post , parameters: ["email": email,"password": password,"phoneNumber": phoneNumber,"firstName": firstName,"lastName": lastName,"adress": adress,"birthDate": birthDate,"type": type])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    
                    let error = data["error"].boolValue
                    if(error){
                       
                        
                        return
                    }
                    
                    let vc = UIStoryboard(name: "LoginStoryboard", bundle: nil) .
                        instantiateViewController(withIdentifier: "login") as? LoginViewController

                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                    print("success")
                    
                    
                }
                
                
                
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("testing")
        datePickerTapped()
    }
    
    
    
    func datePickerTapped() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.txtBirthDate.text = formatter.string(from: dt)
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
