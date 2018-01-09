//
//  OngoingViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 07/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//
import MapKit
import UIKit
import SwiftyJSON
import Alamofire

class OngoingViewController: UIViewController,MKMapViewDelegate,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var map: MKMapView!
    var tasks = [Task]()
    
    var jobId:String?

    @IBOutlet weak var tab: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tab.register(UINib(nibName: "OneTaskCell", bundle: nil), forCellReuseIdentifier: "cellTask")
        
        LoadTaskList()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask", for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.LabelName.text = task.name!
        cell.LabelDesc.text = task.desc!
        cell.LabelFrom.text = task.from!
        
        return cell
    }
    
    func LoadTaskList(){
        Alamofire.request(AppDelegate.serverUrlTaha+"getTaskListParentByJobId?id="+jobId!, method: .get)
            
            .responseJSON { response in
                
                if let json = response.data {
                    let data = JSON(data: json)
                    
                    for task in data.array! {
                        let t = Task(name: task["task"].stringValue,desc: task["details"].stringValue, from: task["time"].stringValue, to: "")
                        self.tasks.append(t)
                        
                    }
                    self.tab.reloadData()
                    
                    
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
