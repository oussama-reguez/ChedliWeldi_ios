//
//  CreateAccountViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/12/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import DatePickerDialog
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
//import EGFormValidator


//class CreateAccountViewController: ValidatorViewController{
    class CreateAccountViewController: UIViewController{
    
    @IBOutlet weak var txtRetypePassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    var type = 0

    var k:UITextField? = nil
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        self.addValidatorMandatory(toControl: txtEmail,
                                   errorPlaceholder: txtEmail,
                                   errorMessage: "Email is required")
        
        self.addValidatorEmail(toControl: txtEmail,
                               errorPlaceholder: txtEmail,
                               errorMessage: "Email is invalid")
       
        self.addValidatorMandatory(toControl: txtPassword,
                                   errorPlaceholder: txtPassword,
                                   errorMessage: "password is required")
        
        self.addValidatorEqualTo(toControl: txtRetypePassword,
                                 errorPlaceholder: txtRetypePassword,
                                 errorMessage: "Passwords don't match",
                                 compareWithControl: txtPassword)
        
        self.addValidatorMinLength(toControl: txtPassword,
                                   errorPlaceholder: txtPassword,
                                   errorMessage: "Enter at least %d characters",
                                   minLength: 5)
 
        
        */
        
              // Do any additional setup after loading the view.
    }
    func tt()  {
       /*
        self.addValidatorMinLength(toControl: txtEmail,  errorPlaceholder: txtEmail,errorMessage: "Enter at least %d characters",minLength: 8)
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createClick(_ sender: Any) {
        
        /*
        if self.validate() {
            validateEmailFromDatabase(email: txtEmail.text!)
        }
        */
        /*
        //validate password matching
        if(txtPassword.text != txtRetypePassword.text){
            print("not matching ")
            return 
        }
        if(!isValidEmail(testStr: txtEmail.text!)){
            
            
         print("email non valide")
            
            return
        }
        
        validateEmailFromDatabase(email: txtEmail.text!)
        
        
        //if()
        */
        
        
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
 
    
    func validateEmailFromDatabase(email:String)
    {
        Alamofire.request(AppDelegate.serverUrl + "validateEmail", method: .post , parameters: ["email": email ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                      print("email exist")
                        self.txtEmail.errorMessage="Email already exist"
                        return
                    }
                    print("success")
                    
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil) .
                        instantiateViewController(withIdentifier: "CreateProfile") as? CreateProfileViewController
                    
                    
                    //  self.showDetailViewController(vc!, sender: nil)
                    //self.present(vc!, animated: true, completion: nil)
                    vc?.type=self.type
                    vc?.email=self.txtEmail.text
                    vc?.password=self.txtPassword.text
                    
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                    
                    
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
