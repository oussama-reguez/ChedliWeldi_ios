//
//  TestingViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/16/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import FoldingCell
import Alamofire
import SwiftyJSON
import Kingfisher


class TestingViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {
    @IBAction func sendRequestAction(_ sender: Any) {
        let offer=offers?[selectedRow]
        let idUser = "4"
         let idOffer = offer?["idOffer"].stringValue
    
        sendRequest(idUser:idUser,idOffer:idOffer! )
        
        /*
        var duration = 0.0
        let cellIsCollapsed = cellHeights[selectedRow] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[selectedRow] = kOpenCellHeight
            selectedCell?.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[selectedRow] = kCloseCellHeight
            selectedCell?.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        */
        
        

    }
    
    
    
    
    @IBOutlet var table: UITableView!
    @IBOutlet var tableView: UITableView!
    
    
 
  

    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var offers:[JSON]? = nil

    
    
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 179// equal or greater foregroundView height
            static let open: CGFloat = 488// equal or greater containerView height
        }
    }
    
    var cellHeights = (0..<10).map { _ in C.CellHeight.close}
    override func viewDidLoad() {
        super.viewDidLoad()
 setup()
        getOffers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(offers == nil) {
            return 0
        }
        return offers!.count
    }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
    
    let offer = offers?[indexPath.row]
    
    
    let img:UIImageView=cell.viewWithTag(101) as! (UIImageView)
    let name:UILabel =   cell.viewWithTag(102) as! (UILabel)
        //let lastName:UILabel =   cell.viewWithTag(103) as! (UILabel)
    let description:UILabel =   cell.viewWithTag(104) as! (UILabel)
    
    //http://localhost:8888/images/man.png
    
    let url = URL(string: AppDelegate.serverImage + offer!["photo"].stringValue)
    img.kf.setImage(with: url)
    let img2:UIImageView=cell.viewWithTag(105) as! (UIImageView)
    img2.kf.setImage(with: url)

    
    
    // img.image=#imageLiteral(resourceName: "man")
    name.text=(offer?["firstName"].stringValue)! + " " + (offer?["lastName"].stringValue)!
    
    description.text=offer?["description"].stringValue
    

    
    
    
    
    
    
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    var selectedCell:FoldingCell? = nil
    var selectedRow:Int = 0
    var selectedOffer:JSON? = nil
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        selectedRow=indexPath.row
        selectedCell=cell
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
    func getOffers()   {
        Alamofire.request(AppDelegate.serverUrl+"offers", method: .get)
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    self.offers = data["offers"].arrayValue
                    self.table.reloadData()
                    
                    print("")
                    
                }
                
                
        }
        
        
    }
    func sendRequest(idUser:String , idOffer:String)
    {
        Alamofire.request(AppDelegate.serverUrl+"sendRequest", method: .post , parameters: ["id_user": idUser , "id_offer": idOffer   ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        
                        return
                    }
                    print("success")
                    
                    
                   //success unfold 
                    
                    
                    
                    
                    
                }
                
                
                
        }
        
    }
    

    

}
