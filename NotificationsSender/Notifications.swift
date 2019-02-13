//
//  Notifications.swift
//  NotificationsSender
//
//  Created by  William on 2/12/19.
//  Copyright © 2019 Vasiliy Lada. All rights reserved.
//

import Foundation
import UserNotifications



private let NotificationCategoryIdentifier = "NOTIFICATION_ACTION"

private let NotificationAcceptActionIdentifier = "ACCEPT_ACTION"
private let NotificationSnoozeActionIdentifier = "SNOOZE_ACTION"
private let NotificationDeleteActionIdentifier = "DELETE_ACTION"

class Notifications: NSObject {
    
    static let NotificationRequestIdentifier = "NOTIFICATION_REQUEST"
    
    var notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        
        let acceptAction = UNNotificationAction(identifier: NotificationAcceptActionIdentifier, title: "Accept", options: [.foreground]) // opens the app
        let snoozeAction = UNNotificationAction(identifier: NotificationSnoozeActionIdentifier, title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
        let deleteAction = UNNotificationAction(identifier: NotificationDeleteActionIdentifier, title: "Delete", options: [.destructive]) // marked as destructive
        
        let notificationActionCategory = UNNotificationCategory(identifier: NotificationCategoryIdentifier, actions: [acceptAction, snoozeAction, deleteAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
        notificationCenter.setNotificationCategories([notificationActionCategory])
    }
    
    /**
      Requests notifiction permissions
     */
    func notificationRequest() {
        notificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if !granted {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification(withTimeInterval: TimeInterval, withSound: Bool, repeating: Bool) {
        notificationCenter.getNotificationSettings { [unowned notificationCenter] settings in
            guard settings.authorizationStatus == .authorized else {
                print("App is not authorized to send notifications!")
                return
            }
            
            // Fill notification content
            let content = UNMutableNotificationContent()
            content.title = "Time Interval Notification"
            content.body = "Just wanna say hello to you"
            if withSound {
              content.sound = UNNotificationSound.default
            }
            content.categoryIdentifier = NotificationCategoryIdentifier // bind defined actions with the notification
            
            // Create a trigger to show the notification in 5 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: withTimeInterval, repeats: repeating)
            
            // Create a request
            let request = UNNotificationRequest(identifier: Notifications.NotificationRequestIdentifier, content: content, trigger: trigger)
            
            // Schedule the request with the system
            notificationCenter.add(request) { (error) in
                if error != nil {
                    print("Unable to schedule notification!")
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    func unscheduleNotification() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [Notifications.NotificationRequestIdentifier])
    }
}

extension Notifications: UNUserNotificationCenterDelegate {
    
    // Show notifications when the app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard response.notification.request.identifier == Notifications.NotificationRequestIdentifier else {
            print("Unknown notification ID")
            return
        }
        print("Handling notifications with the Local Notification Identifier")
        
        switch response.actionIdentifier {
        case NotificationAcceptActionIdentifier:
            print("Accept action selected")
        case NotificationSnoozeActionIdentifier:
            print("Snooze action selected")
        case NotificationDeleteActionIdentifier:
            print("Delete action selected")
        case UNNotificationDismissActionIdentifier:
            print("The user dismissed the notification without taking action (X button)")
        case UNNotificationDefaultActionIdentifier:
            print("The user launched the app (notification tapped)")
        default:
            print("Unknown action selected")
        }
        
        completionHandler()
    }
}
