//
//  AddJobViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 06/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
class AddJobViewController: UIViewController {

    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var jobDate: UILabel!
    @IBOutlet weak var jobDescription: UITextView!
    @IBOutlet weak var map: MKMapView!
    
    var jobId : String = "0"
    var bbyId : String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAddJob(_ sender: Any) {
        if((bbyId ?? "").isEmpty){
            AddJob()
        }else{
            addJobForBbySitter()
        }
    }

    func AddJob(){
        let parameters: Parameters = [
            "id": "30",
            "desc": "qrestdyfughj",
            "date":"2017-07-07",
            "from":"08:00",
            "to":"18:00",
            "longi":"6.00",
            "alt":"6.00"
        ]
        
        // All three of these calls are equivalent
        Alamofire.request(AppDelegate.serverUrlTaha+"AddJob", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                
                //example if there is an id
                let userId = response.object(forKey: "id")!
                self.jobId=userId as! String
                let vc = UIStoryboard(name: "ParentStoryboard", bundle: nil) .
                 instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController
                 
                 //vc?.image=photo.image
                 //vc?.fullName=name.text!
                 
                 vc?.jobId=self.jobId

                self.present(vc!, animated:true, completion:nil)

            case .failure(let error):
                print("Request failed with error: \(error)")
                
            
            }
            
        }
    
    
    }
    
    func addJobForBbySitter(){

        let parameters: Parameters = [
            "id": "30",
            "desc": "qrestdyfughj",
            "date":"2017-07-07",
            "from":"08:00",
            "to":"18:00",
            "longi":"6.00",
            "alt":"6.00",
            "bbId":bbyId!
        ]
        
        // All three of these calls are equivalent
        Alamofire.request(AppDelegate.serverUrlTaha+"AddJobId", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                
                //example if there is an id
                let userId = response.object(forKey: "id")!
                self.jobId="\(userId)"
                self.performSegue(withIdentifier: "seg", sender: self)
             /*   let vc = UIStoryboard(name: "ParentStoryboard", bundle: nil) .
                    instantiateViewController(withIdentifier: "TaskListManagerNav") as? TaskListViewController
                
                //vc?.image=photo.image
                //vc?.fullName=name.text!
                
                vc?.jobId=self.jobId
                
                self.present(vc!, animated:true, completion:nil)
                */
            case .failure(let error):
                print("Request failed with error: \(error)")
                
                
            }
            
        }
        
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navVC = segue.destination as? UINavigationController
        
        let tableVC = navVC?.viewControllers.first as! TaskListViewController
        
        tableVC.jobId = self.jobId
    }


}
