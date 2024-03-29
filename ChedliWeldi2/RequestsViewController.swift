//
//  MyOffersViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/21/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PopupDialog
import FoldingTabBar

class RequestsViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    var requests:[JSON]? = nil
    var offerId:String?="5"
    var detail:String?=nil
    var strDate:String?=nil
    var offer:JSON? = nil
    

    @IBOutlet weak var offerDuration: UILabel!
   
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        // _ = navigationController?.popViewController(animated: true)
        
        if(AppDelegate.userType == "Parent"){
            
            let testController = UIStoryboard(name: "ParentStoryboard", bundle: nil).instantiateViewController(withIdentifier: "Home") as! YALFoldingTabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = testController
            self.present(testController, animated: true, completion: nil)                            }
        else if (AppDelegate.userType == "Babysitter"){
            AppDelegate.userType="Babysitter"
            
            let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BBHome") as! YALFoldingTabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = testController
            self.present(testController, animated: true, completion: nil)
        }
        
    }

    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "h:mm a"
        return formatter
    }()
    
    @IBOutlet weak var offerDate: UILabel!
    @IBOutlet weak var offerDetail: UILabel!
    @IBOutlet weak var nbrRequests: UILabel!
    func showStandardDialog(animated: Bool = true) {
        
        // Prepare the popup
        let title = "THIS IS A DIALOG WITHOUT IMAGE"
        let message = "If you don't pass an image to the default dialog, it will display just as a regular dialog. Moreover, this features the zoom transition"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
            print("Completed")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL") {
          
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "OK") {
          
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }

    
    var requestIdFromNotification:String?=nil
    var selecedRequest:JSON?=nil
    
    func displayDialog(request:JSON , position:Int) {
        let vc = RequestDialogViewController(nibName: "RequestDialog", bundle: nil)
        vc.request = request
        
        
        // vc.photo.kf.setImage(with: url)        // Present dialog
        
        
        // Create the dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Accept", height: 60) {
            
              self.respondToRequest(idRequest: request["id_request"].stringValue, respond: "accepted", position: position)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = indexPath.row
        
         let request = requests?[position]
        selecedRequest=request
        
        displayDialog(request: selecedRequest!,position: position)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RequestsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        offerDetail.text=offer?["description"].stringValue
        var strStart = offer?["start"].stringValue
        var strEnd=offer?["end"].stringValue
        offerId=offer?["id"].stringValue
        nbrRequests.text=(offer?["requests"].stringValue)!+" requests"
       
        
        let dateStart=formatter.date(from: strStart!)
         let dateEnd=formatter.date(from: strEnd!)
        
        
        
        strStart=formatter2.string(from: dateStart!)
        strEnd=formatter2.string(from: dateEnd!)
        
        
        
      formatter2.dateFormat="E"
        let day=formatter2.string(from: dateStart!)
        
        offerDate.text=day+" at "+strStart!+" to " + strEnd!
        
        offerDuration.text=dateEnd?.offsetFrom(date: dateStart!)
        getRequestsByOffer(id: offerId!)

        
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
    @IBOutlet weak var table: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(requests==nil){
            return 0
        }
        
        return requests!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
        
        let request = requests?[indexPath.row]
        
     let lbl1:UILabel =   cell.viewWithTag(101) as! (UILabel)
       
        
        lbl1.text=(request?["firstName"].stringValue)! + " " + (request?["lastName"].stringValue)!
       
        let img:UIImageView=cell.viewWithTag(103) as! (UIImageView)
        
        
        let image = URL(string: AppDelegate.serverImage + request!["photo"].stringValue)
        img.kf.setImage(with: image)
        img.makeItRound()

       
        
        /*
         
         let lbl1:UILabel =   cell.viewWithTag(101) as! (UILabel)
         
         let note:NSManagedObject=notes[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
         let lbl1:UILabel =   cell.viewWithTag(101) as! (UILabel)
         let lbl2:UILabel =   cell.viewWithTag(102) as! (UILabel)
         let img:UIImageView=cell.viewWithTag(103) as! (UIImageView)
         
         */
        
        
        return cell
        
    }
    
    func getRequestsByOffer(id:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getRequestsByOffer", method: .post , parameters: ["id_offer": id ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    self.requests = data["requests"].arrayValue
                   // self.nbrRequests.text = String(describing: self.requests?.count)+" request"
                    self.table.reloadData()
        
                   // self.requestIdFromNotification="1"
                    
                    if(self.requestIdFromNotification != nil)
                    {
                        var count:Int=0
                        self.requests?.forEach{ request in
                            if(request["id_request"].stringValue == self.requestIdFromNotification){
                                self.displayDialog(request: request,position: count)
                                self.requestIdFromNotification=nil
                                count = count + 1
                                return
                            }
                            
                        }
                        
                        
                        
                    }
                    print("")
                    
                }
                
                
        }
        
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
         let secondView:ViewController2 = segue.destination as! ViewController2
         let index:IndexPath=tableView.indexPathForSelectedRow!
         let person   = people[index.row]
         secondView.nom=person.value(forKeyPath: "nom") as! String
         secondView.age=String(person.value(forKeyPath: "age") as! integer_t)
         secondView.moy=String(person.value(forKeyPath: "moyenne") as! float_t)
         secondView.person=person
         */
        
    }
    
    
    func respondToRequest(idRequest:String , respond:String , position :Int)   {
        Alamofire.request(AppDelegate.serverUrl+"respondRequest", method: .post , parameters: ["id_request": idRequest , "respond":respond ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    
                    if(data["error"].bool)!{
                        return
                    }
                    self.requests?.remove(at: position)
                    self.table.reloadData()
                    
                    
                    //sucesss
                    }
                
                    
                }
                
                
        }
        
        
    
    

}
