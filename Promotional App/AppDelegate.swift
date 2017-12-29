//
//  AppDelegate.swift
//  Promotional App
//
//  Created by Heady on 26/12/17.
//  Copyright © 2017 Heady. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 8.0, *) {
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }else {
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching:types)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name(rawValue:"kFIRMessagingRegistrationTokenRefreshNotification"), object: nil)

        Messaging.messaging().delegate = self as MessagingDelegate
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Go this token \(deviceTokenString)")
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let dict = userInfo["aps"] as! NSDictionary
        let  message: String = dict["alert"] as! String
        print("Hey i got this message:\(message)")
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        Messaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @objc func tokenRefreshNotification(notification: NSNotification) {
        let refreshToken = InstanceID.instanceID().token()
        print("InstanceID token:\(refreshToken)")
        connectToFCM()
    }
    
    func connectToFCM() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect FCM")
            }else {
                print("Connected to FCM")
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }
}

/*
 if #available(iOS 10, *) {
 UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
 
 guard error == nil else {
 //Display Error.. Handle Error.. etc..
 return
 }
 
 if granted {
 //Do stuff here..
 
 //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
 application.registerForRemoteNotifications()
 }
 else {
 //Handle user denying permissions..
 }
 }
 
 //Register for remote notifications.. If permission above is NOT granted, all notifications are delivered silently to AppDelegate.
 application.registerForRemoteNotifications()
 }
 else {
 let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
 application.registerUserNotificationSettings(settings)
 application.registerForRemoteNotifications()
 }
 */

