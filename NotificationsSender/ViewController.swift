//
//  ViewController.swift
//  NotificationsSender
//
//  Created by  William on 2/11/19.
//  Copyright © 2019 Vasiliy Lada. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    var notificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request notifications permissions
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if !granted {
                print("User has declined notifications")
            }
        }
        
        // We can check reprmissions before sending any notifications
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                print("App is not authorized to send notifications!")
                return
            }
            
            if settings.alertSetting == .enabled {
                print("Alert settings enabled")
            }
        }
    }

    @IBAction func showNotificationButtonPressed(_ sender: UIButton) {
        notificationCenter.getNotificationSettings { [unowned notificationCenter] (settings) in
            guard settings.authorizationStatus == .authorized else {
                print("App is not authorized to send notifications!")
                return
            }
            
            // Fill notification content
            let content = UNMutableNotificationContent()
            content.title = "Hello"
            content.body = "Just wanna say hello to you"
            content.sound = UNNotificationSound.default
            
            // Create a trigger to show the notification in 3 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            
            // Create a request
            //let uuidString = UUID().uuidString
            let identifier = "Local Notification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            // Schedule the request with the system
            notificationCenter.add(request) { (error) in
                if error != nil {
                    print("Unable to schedule notification!")
                    print(error!.localizedDescription)
                }
            }
        }
        
        
    }
    
}

