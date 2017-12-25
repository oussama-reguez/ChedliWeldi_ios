//
//  ProfileTabsViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 12/5/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import  XLPagerTabStrip

class ProfileTabsViewController: ButtonBarPagerTabStripViewController {

    
     var test:String = "sdfprofile"
     var about:String = "sdfprofile"
    
    let redColor = UIColor(red: 221/255.0, green: 0/255.0, blue: 19/255.0, alpha: 1.0)
    let unselectedIconColor = UIColor(red: 73/255.0, green: 8/255.0, blue: 10/255.0, alpha: 1.0)
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    
     var idUser:String = "4"
    
    
    override func viewDidLoad() {
        
      
        
     //   let viewController =   self.parent as! ProfileViewController
        // change selected bar color
        settings.style.buttonBarBackgroundColor =  UIColor(red: 189/255.0, green: 195/255.0, blue: 199/255.0, alpha: 1.0)

        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        super.viewDidLoad()
                
              //let m = self.parent as! ProfileViewController
        //let k = m.test
        
        
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let photos = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photos") as! PhotosViewController
        let reviews = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rev") as! ReviewsViewController
        let about = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "about") as! AboutViewController
        
        /*
        let child_1 = ChildExampleViewController(itemInfo: IndicatorInfo(title: " ACCOUNT"))
        let child_2 = ChildExampleViewController(itemInfo: IndicatorInfo(title: " ACCOUNT2"))
       */
        return [about, photos, reviews]
    }
    
    
    
    
 

}
