//
//  ReviewsViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/29/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON
import PopupDialog

class ReviewsViewControllerBackupr: UIViewController  ,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var btnFavorite: UIView!
    @IBOutlet weak var btnRate: UIView!
    @IBOutlet weak var btnChat: UIView!
    @IBOutlet weak var profilImage: UIImageView!
    var fullName:String="user ben user"
    var image:UIImage?=nil
    var userId:String="4"

    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var globalRate: CosmosView!
    @IBOutlet weak var nbrReviews: UILabel!
    @IBOutlet weak var profilName: UILabel!
    var reviews:[JSON]? = nil
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        profilImage.image=image
        profilName.text=fullName
        btnRate.layer.borderWidth = 2
        btnRate.layer.borderColor = UIColor.white.cgColor
        
        btnChat.layer.borderWidth = 2
        btnChat.layer.borderColor = UIColor.white.cgColor
        
        btnFavorite.layer.borderWidth = 2
        btnFavorite.layer.borderColor = UIColor.white.cgColor
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.btnRateAction(_:)))
        
        btnRate.addGestureRecognizer(gesture)
        getReviews(idUser: userId)

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(reviews == nil) {
            return 0
        }
        return reviews!.count    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
        
        
         
         
        let review:JSON=(reviews?[indexPath.row])!
      //   let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
         let lbl1:UILabel =   cell.viewWithTag(102) as! (UILabel)
         let lbl2:UILabel =   cell.viewWithTag(103) as! (UILabel)
        let rate:CosmosView =   cell.viewWithTag(104) as! (CosmosView)
        let lbl3:UITextView =   cell.viewWithTag(105) as! (UITextView)
         let img:UIImageView=cell.viewWithTag(101) as! (UIImageView)
        
        let url = URL(string: AppDelegate.serverImage + review["photo"].stringValue)
        img.kf.setImage(with: url)
        lbl1.text=review["firstName"].stringValue + " " + review["lastName"].stringValue
        let stringDate=review["date"].stringValue
       
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"

        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "EE, MMM d, yyyy"

        
        let date = dateFormatter.date(from: stringDate)
        
    
        lbl2.text=dateFormatter2.string(from: date!)
        //EEEE, MMM d, yyyy
        lbl3.text=review["comment"].stringValue
        rate.rating=review["rate"].doubleValue
        
        
        return cell
        
    }
    
    func getReviews(idUser:String)   {
        Alamofire.request(AppDelegate.serverUrl+"reviews", method: .post , parameters: ["user_id": idUser])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    self.reviews = data["reviews"].arrayValue
                    let data2:JSON = data["data"]
                    self.nbrReviews.text="Reviews " + data2["count"].stringValue
                    self.globalRate.rating=data2["rate"].doubleValue
                    self.tableView.reloadData()
                    
                    print("")
                    
                }
                
                
        }
        
        
    }
    
    
    func btnRateAction(_ sender:UITapGestureRecognizer){
        
        
      displayDialog(fullName:fullName)
        
        
    }
    
    
    func displayDialog(fullName:String) {
        let vc = RatingDialogViewController(nibName: "RatingDialog", bundle: nil)
        vc.fullName = fullName
        
        
        // vc.photo.kf.setImage(with: url)        // Present dialog
        
        
        // Create the dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "send", height: 60) {
            
            
               let rating = vc.rating.rating
            let comment = vc.txtComment.text
            
            
            let idReviewer="6"
            
            
            let f = String(rating)
       print("helo")
            
               self.sendReview(idUser: self.userId, idReviewer: idReviewer, rate: String(rating), comment: comment!)
            
            
            
            
            
            
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
        
    }
    
    
    func sendReview(idUser:String , idReviewer:String,rate:String,comment:String)
    {
        Alamofire.request(AppDelegate.serverUrl+"sendReview", method: .post , parameters: ["user_id": idUser , "reviewer_id": idReviewer , "rate": rate, "comment": comment   ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        
                        return
                    }
                    print("success")
                   self.getReviews(idUser: self.userId)
                    
                    
                    
                    //success unfold
                    
                    
                    
                    
                    
                }
                
                
                
        }
        
    }
    
    
    

}
