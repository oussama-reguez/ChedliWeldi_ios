//
//  ProfileViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 12/5/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var btnFavorite: UIView!
    @IBOutlet weak var btnRate: UIView!
    @IBOutlet weak var btnChat: UIView!
    @IBOutlet weak var profilImage: UIImageView!
     @IBOutlet weak var profilName: UILabel!
    var test:String = "sdfprofile"
      var idUser:String = "4"
      var about:String = "about about about about "
    var fullName:String = "oussamareguez"
     var image:UIImage?=nil
    

    func messageAction(_ sender:UITapGestureRecognizer){
        
        let destination = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "chat") as? ChatViewController
        destination?.idSender=idUser
        self.navigationController?.pushViewController(destination!, animated: true)
        
    }
    
    override func viewDidLoad() {
        btnRate.layer.borderWidth = 2
        btnRate.layer.borderColor = UIColor.white.cgColor
        profilImage.image=image
        profilImage.makeItRound()
        profilName.text=fullName
        btnChat.layer.borderWidth = 2
        btnChat.layer.borderColor = UIColor.white.cgColor
        
        
        let gestureMessage = UITapGestureRecognizer(target: self, action: #selector(self.messageAction(_:)))
        
        btnChat.addGestureRecognizer(gestureMessage)
        btnFavorite.layer.borderWidth = 2
        btnFavorite.layer.borderColor = UIColor.white.cgColor
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.btnFavoriteAction(_:)))
        
       
        
        btnFavorite.addGestureRecognizer(gesture)
        
        
        


        // Do any additional setup after loading the view.
    }

    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tabs")
        {
            let cv = segue.destination as! ProfileTabsViewController
            cv.idUser=idUser
        
        }
    }
    
    
    func btnFavoriteAction(_ sender:UITapGestureRecognizer){
        
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "favorites") as? FavoriteDialogViewController
        
        //vc?.image=photo.image
        //vc?.fullName=name.text!
        
        
        vc?.idUser=idUser
        self.present(vc!, animated:true, completion:nil)


        
        
    }


}
