//
//  BabysitterListViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 06/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import FoldingCell
import SwiftyJSON


class BabysitterListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    var cellHeights = (0..<10).map { _ in C.CellHeight.close}

    var babysitters:[JSON]? = nil
    let kCloseCellHeight: CGFloat = 200
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var selectedCell:FoldingCell? = nil
    var selectedRow:Int = 0

   
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getBabysitters()
        
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
    func setup() {
        table.register(UINib(nibName: "BabysitterFolding", bundle: nil), forCellReuseIdentifier: "FoldingCell")
        table.separatorStyle = .none
       // cellHeights = Array(repeating: kCloseCellHeight, count: babysitters!.count)
        table.estimatedRowHeight = kCloseCellHeight
        table.rowHeight = UITableViewAutomaticDimension
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(babysitters == nil) {
            return 0
        }
        return babysitters!.count    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! BabysitterCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        let babysitter = babysitters?[indexPath.row]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.apply((babysitter?["image"].stringValue)!, name: (babysitter?["firstname"].stringValue)!+" "+(babysitter?["lastname"].stringValue)!, descr: (babysitter?["descr"].stringValue)!)
        cell.onButtonTapped={
            print("going")
            let content = self.storyboard!.instantiateViewController(withIdentifier: "AddJob") as! AddJobViewController
            content.bbyId = babysitter?["id"].stringValue
            self.present(content, animated: true, completion: nil)            
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }

        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell

            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell

            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let cell as FoldingCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                cell.unfold(false, animated: false, completion:nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }
    }


    
    func getBabysitters()   {
        Alamofire.request(AppDelegate.serverUrlTaha+"getBabysitters", method: .get)
            
            .responseJSON { response in
                
                if let json = response.data {
                    let data = JSON(data: json)

                    self.babysitters = data.arrayValue
                    self.table.reloadData()
                    
                    
                }
        }
    }
    
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 200 // equal or greater foregroundView height
            static let open: CGFloat = 488// equal or greater containerView height
        }

  }
}
