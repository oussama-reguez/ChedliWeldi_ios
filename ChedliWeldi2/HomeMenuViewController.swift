//
//  HomeMenuViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 06/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftyJSON

class HomeMenuViewController: UIViewController {
    fileprivate var selectedIndex = 0
    fileprivate var transitionPoint: CGPoint!
    fileprivate var contentType: ContentType = .Music
    fileprivate var navigator: UINavigationController!
    var jobId : String?
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnFiltre(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (.some("presentMenu"), let menu as MenuViewController):
            print("")
            /*menu.selectedItem = selectedIndex
            menu.delegate = self
            menu.transitioningDelegate = self
            menu.modalPresentationStyle = .custom*/
        case (.some("embedNavigator"), let navigator as UINavigationController):
            print("")
         //   self.navigator = navigator
         //   self.navigator.delegate = self
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

