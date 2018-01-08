//
//  ViewController.swift
//  FSCalendarSwiftExample
//
//  Created by Wenchao Ding on 9/3/15.
//  Copyright (c) 2015 wenchao. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import SwiftyJSON
class InterfaceBuilderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate ,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet
    weak var calendar: FSCalendar!
      var offers:[JSON]? = nil
    
     var dates = [Date]()
    
    func getDates(table:[JSON]) -> [Date]  {
        var dates = [Date]()
        table.forEach{ d in
            let strDate=d["date"].stringValue
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd"

            dates.append(formatter.date(from: strDate)!)
            
        }
        
        
        
        return dates
    
    }

    
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet
    weak var calendarHeightConstraint: NSLayoutConstraint!
    
    fileprivate var lunar: Bool = false {
        didSet {
            self.calendar.reloadData()
        }
    }
    fileprivate var theme: Int = 0 {
        didSet {
            switch (theme) {
            case 0:
                self.calendar.appearance.weekdayTextColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.calendar.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.calendar.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendar.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendar.appearance.headerDateFormat = "MMMM yyyy"
                self.calendar.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                self.calendar.appearance.borderRadius = 1.0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 0.2
            case 1:
                self.calendar.appearance.weekdayTextColor = UIColor.red
                self.calendar.appearance.headerTitleColor = UIColor.darkGray
                self.calendar.appearance.eventDefaultColor = UIColor.green
                self.calendar.appearance.selectionColor = UIColor.blue
                self.calendar.appearance.headerDateFormat = "yyyy-MM";
                self.calendar.appearance.todayColor = UIColor.red
                self.calendar.appearance.borderRadius = 1.0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
            case 2:
                self.calendar.appearance.weekdayTextColor = UIColor.red
                self.calendar.appearance.headerTitleColor = UIColor.red
                self.calendar.appearance.eventDefaultColor = UIColor.green
                self.calendar.appearance.selectionColor = UIColor.blue
                self.calendar.appearance.headerDateFormat = "yyyy/MM"
                self.calendar.appearance.todayColor = UIColor.orange
                self.calendar.appearance.borderRadius = 0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 1.0
            default:
                break;
            }
        }
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    fileprivate let datesWithCate = ["2015/05/05","2015/06/05","2015/07/05","2015/08/05","2015/09/05","2015/10/05","2015/11/05","2015/12/05","2016/01/06",
    "2016/02/06","2016/03/06","2016/04/06","2016/05/06","2016/06/06","2016/07/06"]
    

    
    // MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
       // let date = Date()
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.calendar.select(Date())
        
        
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        let myString = formatter.string(from: Date())
        
        
        
        getDates(idUser: AppDelegate.userId)


    }
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {

    return nil
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2018/01/28")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
      //  let day: Int! = self.gregorian.component(.day, from: date)
                return self.dates.contains(date) ? 1 : 0
    
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        //let day: Int! = self.gregorian.component(.day, from: date)
       // return [13,24].contains(day) ? UIImage(named: "icon_cat") : nil
        
    return self.dates.contains(date) ? #imageLiteral(resourceName: "baby"): nil
    
    }
    
    // MARK:- FSCalendarDelegate

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(self.formatter.string(from: date))")
        
        
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        getOffers(idUser: AppDelegate.userId,date: self.formatter.string(from: date))
        
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    
    @IBAction
    func unwind2InterfaceBuilder(segue: UIStoryboardSegue) {
        
            }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let offer = offers?[indexPath.row]
        let destination = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "scheduledBabysitter") as? ScheduledBabysitterOfferViewController
        
        
        destination?.offer=offer
        
        self.navigationController?.pushViewController(destination!, animated: true)
        return
        
        
    }
    
    func getOffers(idUser:String , date:String)
    {
        Alamofire.request(AppDelegate.serverUrl+"getCalendarByDate", method: .post , parameters: ["id_user": idUser , "date": date  ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        
                        self.offers = [JSON]()
                            self.table.reloadData()
                        

                        
                        return
                    }
                    print("success")
                    
                    
                    self.offers = data["offers"].arrayValue
                    self.table.reloadData()
                    
                    return
                    //success unfold
                    
                    
                    
                    
                    
                }
                
                
                
        }
        
    }

    
    func getDates(idUser:String)
    {
        Alamofire.request(AppDelegate.serverUrl+"getDates", method: .post , parameters: ["id_user": idUser])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        
                        return
                    }
                    print("success")
                    
                    
                    
                    self.dates=self.getDates(table: data["dates"].arrayValue)
                    
                   
                    self.calendar.reloadData()
                    //success unfold
                    
                    
                    
                    
                    
                }
                
                
                
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(offers == nil) {
            return 0
        }
        return offers!.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath)
        
        
        let offer = offers?[indexPath.row]
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        let m = offer?["start"].stringValue
        let d = offer?["end"].stringValue
        
       
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date=formatter.date(from: (offer?["start"].stringValue)!)
        let end=formatter.date(from: (offer?["end"].stringValue)!)
        
        
        
        
        let day:UILabel =   cell.viewWithTag(101) as! (UILabel)
        let month:UILabel =   cell.viewWithTag(102) as! (UILabel)
        let img:UIImageView=cell.viewWithTag(103) as! (UIImageView)
        let name:UILabel =   cell.viewWithTag(104) as! (UILabel)
        let hours:UILabel =   cell.viewWithTag(105) as! (UILabel)
        
         formatter.dateFormat = "MMM"
        
        let strMonth=formatter.string(from: date!)
       
          formatter.dateFormat = "dd"
        
        let strDay = formatter.string(from: date!)
        day.text = strDay
        month.text=strMonth

          formatter.dateFormat = "h:mm a"
        
        let hourStart = formatter.string(from: date!)
        let hourEnd=formatter.string(from: end!)

        hours.text=hourStart + " - " + hourEnd
        name.text=(offer?["firstName"].stringValue)! + " " + (offer?["lastName"].stringValue)!
        
        
        let url = URL(string: AppDelegate.serverImage + offer!["photo"].stringValue)
         img.kf.setImage(with: url)
        // img.image=#imageLiteral(resourceName: "man")
        
        
      
        
        
        
        
        
        
        
        
        
        return cell
    }    
    
    
}

