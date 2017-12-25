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

class RatingDialogViewController: UIViewController {
    
   
    @IBOutlet weak var txtComment: UITextView!
   
    @IBOutlet weak var rating: CosmosView!
   
    @IBOutlet weak var lblName: UILabel!
    
    var request:JSON=nil
    var fullName:String = ""
   
    @IBOutlet weak var name: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       lblName.text="Rating for " + fullName
        var tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RatingDialogViewController.textAction(_:)))
        self.txtComment.addGestureRecognizer(tapOutTextField)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func dialerAction(_ sender:UITapGestureRecognizer){
        print("heheirh")
        
        callNumber(phoneNumber: request["phoneNumber"].stringValue)
        
    }

    var once:Bool=false
    func textAction(_ sender:UITapGestureRecognizer){
        if(!once){
            print("heheirh")
            txtComment.alpha=1
            txtComment.text=""
            once=true
        }
        
       
        
    }

    
    func whatAppAction(_ sender:UITapGestureRecognizer){
        
        let urlWhats = "whatsapp://send?phone=+216"+request["phoneNumber"].stringValue+"&abid=12354&text=Hi"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.openURL(whatsappURL)
                } else {
                    print("Install Whatsapp")
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
