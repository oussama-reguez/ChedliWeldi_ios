//
//  AppDelegate.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 11/12/17.
//  Copyright © 2017 Esprit. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {

    var window: UIWindow?
    static let  serverUrl="http://localhost:8888/rest/v1/"
    static let  serverUrlTaha="http://192.168.1.7/rest/v1/"
    static let  serverUrlTahaImage="http://192.168.1.7/images/"
    static let  connectedUser="5"
    static let serverImage="http://localhost:8888/images/"
    static let userId="30"
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    registerForRemoteNotification()
      /*
        let storyBoard = UIStoryboard(name: "testing", bundle: nil)
        
       //let secondVC = storyBoard.instantiateViewController(withIdentifier: "first") as! PhotosViewController
         let secondVC2 = storyBoard.instantiateViewController(withIdentifier: "youtube")  as! YoutubeExampleViewController
        self.window?.rootViewController = secondVC2
 */
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ChedliWeldi2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
               
                }
                let generalCategory = UNNotificationCategory(identifier: "newCategory",
                                                             actions: [],
                                                             intentIdentifiers: [],
                                                             options: .customDismissAction)
                
             
                center.setNotificationCategories([generalCategory])
                
                
            }
            
            
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
    
        
       // let fileURL: URL = ... //  your disk file url, support image, audio, movie
        
       // let attachement = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil)
     //   content.attachments = [attachement!]
        /*
        let request = UNNotificationRequest.init(identifier: "newNotificationRequest", content: content, trigger: nil)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
 */
        completionHandler([.alert, .badge, .sound ])
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeC = storyboard.instantiateViewController(withIdentifier: "Requests") as? RequestsViewController
    let userInfo =    response.notification.request.content.userInfo

       
    
        
            let offerId = userInfo["offer_id"] as? NSString
            let requestId = userInfo["request_id"] as? NSString

                homeC?.offerId=offerId! as String
        
                 homeC?.requestIdFromNotification=requestId! as String
        
                //Do stuff
            
        
        

        if homeC != nil {
            homeC!.view.frame = (self.window!.frame)
            self.window!.addSubview(homeC!.view)
            self.window!.bringSubview(toFront: homeC!.view)
            //homeC.getMyNotifcations()
        }
        // completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        
    }
}

