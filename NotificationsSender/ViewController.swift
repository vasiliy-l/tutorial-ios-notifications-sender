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
    }

    @IBAction func showNotificationButtonPressed(_ sender: UIButton) {
        notificationCenter.getNotificationSettings { [unowned notificationCenter] (settings) in
            guard settings.authorizationStatus == .authorized else {
                print("App is not authorized to send notifications!")
                return
            }
            
            // Define custom actions
            let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Accept", options: [.foreground]) // opens the app
            let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
            let deleteAction = UNNotificationAction(identifier: "DELETE_ACTION", title: "Delete", options: [.destructive]) // marked as destructive
            
            let notificationActionCategory = UNNotificationCategory(identifier: "NOTIFICATION_ACTION", actions: [acceptAction, snoozeAction, deleteAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
            
            notificationCenter.setNotificationCategories([notificationActionCategory])
            
            // Fill notification content
            let content = UNMutableNotificationContent()
            content.title = "Hello"
            content.body = "Just wanna say hello to you"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "NOTIFICATION_ACTION" // bind defined actions with the notification
            
            // Create a trigger to show the notification in 5 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            // Create a request
            //let identifier = UUID().uuidString
            let identifier = "LOCAL_NOTIFICATION"
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

