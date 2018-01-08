//
//  TaskListViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 06/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TaskListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    var jobId : String = "0"
    var tasks = [Task]()
    @IBOutlet weak var tab: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tab.register(UINib(nibName: "OneTaskCell", bundle: nil), forCellReuseIdentifier: "cellTask")
        // Do any additional setup after loading the view.
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

    @IBOutlet weak var btnSave: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnAdd(_ sender: UIButton) {
        
    }
    
    
    @IBAction func btnSaveTaskList(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ParentStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home")
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddTaskViewController, let task = sourceViewController.task {
            // Add a new Task.
            let newIndexPath = IndexPath(row: tasks.count, section: 0)
            
            tasks.append(task)
            tab.insertRows(at: [newIndexPath], with: .automatic)
            
            addTaskToJob(taskToUpload: task)
        
        }
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    func addTaskToJob(taskToUpload task:Task){
        let parameters: Parameters = [
            "idJob": jobId,
            "task": task.name ?? "Task default name",
            "details":task.desc ?? "details defautlt",
            "time":task.from ?? "08:00"
        ]
        print(parameters)
        // All three of these calls are equivalent
        Alamofire.request(AppDelegate.serverUrlTaha+"AddTask", method: .post, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                
                
            }
            
        }

    }


}
