    //
    //  AppDelegate.swift
    //  Roll_Call
    //
    //  Created by Anthony Powell on 8/22/15.
    //  Copyright (c) 2015 Anthony Powell. All rights reserved.
    //
    
    import UIKit
    import Firebase
    //import GoogleSignIn
    
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        
        override init() {
            FirebaseApp.configure()
        }
        
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            //        FirebaseApp.configure()
            //MARK -TESTING
            do{
                try Auth.auth().signOut()
            }catch{
                print("didn't sign user out")
            }
            
            
            let storyboard =  UIStoryboard(name: "Main", bundle: Bundle.main)
            let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(LoginVC, animated: true, completion: nil)
            print("NO USER")
            
            //        if Auth.auth().currentUser == nil{
            //
            //            let storyboard =  UIStoryboard(name: "Main", bundle: Bundle.main)
            //            let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            //            window?.makeKeyAndVisible()
            //            window?.rootViewController?.present(LoginVC, animated: true, completion: nil)
            //            print("NO USER")
            //        }else{
            //            //MARK
            ////            do{
            ////                try Auth.auth().signOut()
            ////            }catch{
            ////                print("didn't sign user out")
            ////            }
            //
            //            print("USER FOUND")
            //        }
            return true
        }
        
        
        
        func applicationWillResignActive(_ application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        }
        
        func applicationDidEnterBackground(_ application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
        
        func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        }
        
        func applicationDidBecomeActive(_ application: UIApplication) {
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
        
        
    }
    
