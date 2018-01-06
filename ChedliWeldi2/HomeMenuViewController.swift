//
//  HomeMenuViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 06/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import SideMenu


class HomeMenuViewController: UIViewController {
    fileprivate var selectedIndex = 0
    fileprivate var transitionPoint: CGPoint!
    fileprivate var contentType: ContentType = .Music
    fileprivate var navigator: UINavigationController!
    
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnFiltre(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (.some("presentMenu"), let menu as MenuViewController):
            menu.selectedItem = selectedIndex
            menu.delegate = self
            menu.transitioningDelegate = self
            menu.modalPresentationStyle = .custom
        case (.some("embedNavigator"), let navigator as UINavigationController):
            self.navigator = navigator
            self.navigator.delegate = self
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension HomeMenuViewController: MenuViewControllerDelegate {
    
    func menu(_: MenuViewController, didSelectItemAt index: Int, at point: CGPoint) {
        contentType = !contentType
        transitionPoint = point
        selectedIndex = index
        switch index {
        case 0:
        
            let content = storyboard!.instantiateViewController(withIdentifier: "Content") as! TabsViewController
            navigator.setViewControllers([content], animated: true)
        
            
        case 1:
            let content = storyboard!.instantiateViewController(withIdentifier: "AddJob") as! AddJobViewController
            navigator.setViewControllers([content], animated: true)
            
        default:
            let content = storyboard!.instantiateViewController(withIdentifier: "Content") as! TabsViewController
            navigator.setViewControllers([content], animated: true)
            
        
        }
        
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func menuDidCancel(_: MenuViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension HomeMenuViewController: UINavigationControllerDelegate {
    
    func navigationController(_: UINavigationController, animationControllerFor _: UINavigationControllerOperation,
                              from _: UIViewController, to _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let transitionPoint = transitionPoint {
            return CircularRevealTransitionAnimator(center: transitionPoint)
        }
        return nil
    }
}

extension HomeMenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
                             source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return menuAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
}
