//
//  AppDelegate.swift
//  Awards
//
//  Created by Mihnea on 6/27/22.
//

import UIKit
import FirebaseCore
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        initializeOneSignal(launchOptions: launchOptions)
        setupExternalId()
        
        
        return true
    }
    
    private func checkNotifPrefs() -> Bool {
        var userPrefs = UserPrefs()
        
        do {
            if let savedData = UserDefaults.init(suiteName: "group.mihnea.Awards")!.data(forKey: "mihnea.users.preferences") {
                let decoder = JSONDecoder()
                userPrefs = try decoder.decode(UserPrefs.self, from: savedData)
            }
        } catch {print("lasa")}
        
        return userPrefs.limitedEditToggle
    }
    
    private func initializeOneSignal(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("5c138eb0-f9cb-46e1-9dac-eb7aec4d1cd3")
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
    }
    
    private func setupExternalId() {
        let externalUserId = randomString(of: 10)
        
        OneSignal.setExternalUserId(externalUserId, withSuccess: { results in
            print("External user id update complete with results: ", results!.description)
            if let pushResults = results!["push"] {
                print("Set external user id push status: ", pushResults)
            }
            if let emailResults = results!["email"] {
                print("Set external user id email status: ", emailResults)
            }
            if let smsResults = results!["sms"] {
                print("Set external user id sms status: ", smsResults)
            }
        }, withFailure: {error in
            print("Set external user id done with error: " + error.debugDescription)
        })
    }
    
    
    private func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
        
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }
    
}

