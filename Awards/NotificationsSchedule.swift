//
//  NotificationsSchedule.swift
//  Awards
//
//  Created by Mihnea on 7/7/22.
//

import Foundation
import UserNotifications
import BackgroundTasks
import UIKit

class NotificationsSchedule : Operation{
    var userPrefs = UserPrefs()
    
    func leSchedule() {
        loadUserPrefs()
        if userPrefs.limitedEditToggle{
            var data = [leChallenges]()
            
            getLEApi() { challenges in
                data = challenges
            }
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                for data in data {
                    content.title = data.name
                    content.body = "New limited edition challenge available today!"
                    content.sound = UNNotificationSound.default
                    content.interruptionLevel = .timeSensitive
                    
                    var dateComponents = DateComponents()
                    dateComponents.month = data.month
                    dateComponents.day = data.day
                    dateComponents.hour = 7
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: data.id, content: content, trigger: trigger)
                    center.add(request)
                }
            }
        }
    }
    
    func loadUserPrefs() {
        do {
            if let savedData = UserDefaults.init(suiteName: "group.mihnea.Awards")!.data(forKey: "mihnea.users.preferences") {
                let decoder = JSONDecoder()
                userPrefs = try decoder.decode(UserPrefs.self, from: savedData)
            }
        } catch {print("lasa")}
    }
    
    func getLEApi(completion: @escaping([leChallenges]) -> ()) {
        guard let url = URL(string: "https://api.npoint.io/1238629f42de00e5387c") else {return}
        URLSession.shared.dataTask(with: url) { data, _, _ in
            do {
                let challenges = try JSONDecoder().decode([leChallenges].self, from: data!)
                DispatchQueue.main.async {
                    completion(challenges)
                }
            } catch {print("\(error.localizedDescription)")}
        }
        .resume()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.Mihnea.awards.bgNotifications")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        OperationQueue().addOperation {
            self.leSchedule()
        }
        
        print("WORKED!!!!")
    }
}
