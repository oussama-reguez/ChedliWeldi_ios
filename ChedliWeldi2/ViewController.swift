//
//  ViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/12/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import EGFormValidator

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tt: UIImageView!
    @IBOutlet weak var babySitterView: UIView!
    @IBOutlet weak var parentView: UIView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
       //register(email: "oussamadd@gmail.com", password: "dfd", phoneNumber: 23524823, firstName: "salim", lastName: "fedd", adress: "sdfsdf", birthDate: "23-03-2002", type: 1)
        
       // getOffers()
       // validateEmailFromDatabase(email: "oussamareguez@gmail.com")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.parentAction(_:)))
        
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.babySitterAction(_:)))
        
        parentView.addGestureRecognizer(gesture)
        
        babySitterView.addGestureRecognizer(gesture2)
        
    }
   
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parentAction(_ sender:UITapGestureRecognizer){
       
        let vc = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "CreateAccount") as? CreateAccountViewController
                self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func babySitterAction(_ sender:UITapGestureRecognizer){
       
        
        let vc = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "CreateAccount") as? CreateAccountViewController
         vc?.type=1
        self.navigationController?.pushViewController(vc!, animated: true)
        

    }
    
  
  
   
    
    
}

