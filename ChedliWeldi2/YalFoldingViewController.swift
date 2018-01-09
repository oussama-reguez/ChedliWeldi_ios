//
//  YalFoldingViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 08/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import FoldingTabBar

class YalFoldingViewController: YALFoldingTabBarController ,YALTabBarDelegate{
    var window: UIWindow?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Here")
        // Do any additional setup after loading the view.
        setupYALTabBarController()

    
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
    
    func setupYALTabBarController() {
        guard let tabBarController = appDelegate.window?.rootViewController as? YalFoldingViewController else {
            print("Else")
            return }
        print("OK")

        let item1 = YALTabBarItem(itemImage: UIImage(named: "nearby_icon"), leftItemImage: nil,rightItemImage: UIImage(named: "edit_icon"))
        let item2 = YALTabBarItem(itemImage: UIImage(named: "profile_icon"), leftItemImage: UIImage(named: "plus_icon"), rightItemImage: nil)
        tabBarController.leftBarItems = [item1, item2]
        
        
        let item3 = YALTabBarItem(itemImage: UIImage(named: "chats_icon"), leftItemImage: UIImage(named: "search_icon"), rightItemImage: UIImage(named: "new_chat_icon"))
        let item4 = YALTabBarItem(itemImage: UIImage(named: "settings_icon"), leftItemImage: nil, rightItemImage: nil)
        tabBarController.rightBarItems = [item3, item4]
        
        tabBarController.centerButtonImage = UIImage(named:"plus_icon")!
        tabBarController.selectedIndex = 0
        
        //customize tabBarView
        tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
        tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
        tabBarController.tabBarView.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0, blue: 149.0/255.0, alpha: 1)
        
        tabBarController.tabBarView.tabBarColor = UIColor(red: 72.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1)
        tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight;
        tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
        tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
    }
    
    
}
