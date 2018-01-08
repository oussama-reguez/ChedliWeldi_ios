//
//  LoginViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 07/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import TransitionButton
import SkyFloatingLabelTextField
import SwiftyJSON
import Alamofire
import FoldingTabBar

class LoginViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var button: TransitionButton!

    @IBOutlet weak var textField1: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var textField2: SkyFloatingLabelTextFieldWithIcon!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // let textFieldframe1 = CGRect(origin: CGPoint(x: 10,y :40), size: CGSize(width: 200, height: 45))
        //let textField1 = SkyFloatingLabelTextFieldWithIcon(frame: textFieldframe1)
        textField1.delegate = self
        textField2.delegate = self
        
        
        
        
        textField1.placeholder = "Email"
        textField1.title = "Your email"
        textField1.iconFont = UIFont(name: "FontAwesome", size: 15)
        textField1.iconText = "\u{f1fa}" // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
        textField1.lineHeight = 1.0 // bottom line height in points
        textField1.lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField1.selectedLineHeight = 2.0
        textField1.selectedLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField1.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        textField1.selectedTitleColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

        self.view.addSubview(textField1)
        
       // let textField2 = SkyFloatingLabelTextFieldWithIcon(frame: CGRect(origin: CGPoint(x: 10,y :100), size: CGSize(width: 200, height: 45)))
        textField2.placeholder = "Password"
        textField2.title = "Your password"
        textField2.iconFont = UIFont(name: "FontAwesome", size: 15)
        textField2.iconText = "\u{f023}" // plane icon as per https://fortawesome.github.io/Font-Awesome/cheatsheet/
        textField2.lineHeight = 1.0 // bottom line height in points
        textField2.lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField2.selectedLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField2.selectedLineHeight = 2.0
        textField2.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        textField2.selectedTitleColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        textField2.isSecureTextEntry = true
        
        self.view.addSubview(textField2)

        
        
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.isEqual(textField1)){
            if let text = textField1.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.characters.count < 3 || !text.contains("@")) {
                        floatingLabelTextField.errorMessage = "Invalid email"
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
 
        }
        return true
    }
    /// Implementing a method on the UITextFieldDelegate protocol. This will notify us when something has changed on the textfield
    

    @IBAction func loginBtn(_ sender: Any) {
        if((textField1.text?.characters.count)!>0 && (textField2.text?.characters.count)!>0){
            
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
           
            let parameters: Parameters = [
                "email": self.textField1.text!,
                "password": self.textField2.text!,
            ]
            print(parameters)
            Alamofire.request(AppDelegate.serverUrlTaha+"login", method: .post, parameters: parameters).responseJSON { response in
                print(response)
                switch response.result {
                case .success(let JSON):
                    print(JSON)
                    let response = JSON as! NSDictionary
                    
                    let userId = response.object(forKey: "id")!
                    print("Success with id user: \(userId)")

                    AppDelegate.userId="\(userId)"
                    AppDelegate.connectedUser = "\(userId)"
                    DispatchQueue.main.async(execute: { () -> Void in
                        // 4: Stop the animation, here you have three options for the `animationStyle` property:
                        // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                        // .shake: when you want to reflect to the user that the task did not complete successfly
                        // .normal
                        self.button.stopAnimation(animationStyle: .expand, completion: {
                            let storyboard = UIStoryboard(name: "ParentStoryboard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "Home")
                            self.present(vc, animated: true, completion: nil)
                        })
                    })
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        // 4: Stop the animation, here you have three options for the `animationStyle` property:
                        // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                        // .shake: when you want to reflect to the user that the task did not complete successfly
                        // .normal
                        self.button.stopAnimation(animationStyle: .shake, completion: nil)
                    })

                }
                
            }
            
            
        })
    }
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

}
