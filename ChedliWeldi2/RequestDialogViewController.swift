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

class RequestDialogViewController: UIViewController {
    
    
    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var dialer: UIImageView!
    @IBOutlet weak var whatApp: UIImageView!
    @IBOutlet weak var photo: UIImageView!
   
   
    
    @IBAction func reviewsAction(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "Profile") as? ProfileViewController
        
        //vc?.image=photo.image
        //vc?.fullName=name.text!
        
        let id = request["id"].stringValue
        vc?.idUser=id
        vc?.image=photo.image
        
        
         self.present(vc!, animated:true, completion:nil)
    }
    var request:JSON=nil
   
    @IBOutlet weak var name: UILabel!
    
      

    override func viewDidLoad() {
        super.viewDidLoad()
       
        name.text=(request["firstName"].stringValue) + " " + (request["lastName"].stringValue)
        let url = URL(string: AppDelegate.serverImage + request["photo"].stringValue)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(RequestDialogViewController.dialerAction(_:)))
        let nbrRate = request["rate"].doubleValue
        rate.rating=nbrRate
        
        dialer.addGestureRecognizer(gesture)
        dialer.isUserInteractionEnabled=true
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(RequestDialogViewController.whatAppAction(_:)))
        
      
         whatApp.addGestureRecognizer(gesture2)
        whatApp.isUserInteractionEnabled=true

        photo.kf.setImage(with: url)

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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    print("")
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
