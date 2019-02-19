//
//  NotificationViewController.swift
//  NotificationExtension
//
//  Created by  William on 2/14/19.
//  Copyright © 2019 Vasiliy Lada. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel!
    
    let notifications = Notifications()
    var originalNotification: UNNotificationContent?
    static var retiesAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func openApp() {
        extensionContext?.performNotificationDefaultAction()
    }
    
    func dismissNotification() {
        extensionContext?.dismissNotificationContentExtension()
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        showSnoozeActions()
    }

    func didReceive(_ notification: UNNotification) {
        originalNotification = notification.request.content
        
        self.label.text = notification.request.content.body
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        switch response.actionIdentifier {
        case "SNOOZE_ACTION":
            showSnoozeActions()
        case "ACCEPT_ACTION":
            completion(.dismissAndForwardAction)
        case "DELETE_ACTION":
            completion(.dismiss)
            
        // snooze actions
        case "SNOOZE_3SEC":
            print("Snooze for 3 secs selected")
            NotificationViewController.retiesAmount += 1
            snoozeNotification(time: 3)
            completion(.dismiss)
        case "SNOOZE_1MIN":
            print("Snooze for 1 minute selected")
            NotificationViewController.retiesAmount += 1
            snoozeNotification(time: 60)
            completion(.dismiss)
        case "SNOOZE_2MIN":
            print("Snooze for 2 minutes selected")
            NotificationViewController.retiesAmount += 1
            snoozeNotification(time: 120)
            completion(.dismiss)
        case "SNOOZE_NO":
            openApp()
            
        default:
            dismissNotification()
        }
    }
    
    func showSnoozeActions() {
        var actions: [UNNotificationAction]
        
        if (NotificationViewController.retiesAmount < 3) {
            actions = [
                UNNotificationAction(
                    identifier: "SNOOZE_3SEC",
                    title: "Snooze for 3 secs",
                    options: []),
                UNNotificationAction(
                    identifier: "SNOOZE_1MIN",
                    title: "Snooze for 1 min",
                    options: []),
                UNNotificationAction(
                    identifier: "SNOOZE_2MIN",
                    title: "Snooze for 2 mins",
                    options: []),
                ]
        }
        else {
            actions = [
                UNNotificationAction(
                    identifier: "SNOOZE_NO",
                    title: "Ha Ha Ha, No",
                    options: [.destructive]),
            ]
            
            NotificationViewController.retiesAmount = 0
        }
        
        extensionContext?.notificationActions = actions
    }
    
    func snoozeNotification(time: TimeInterval) {
        if let originalNotification = originalNotification {
            notifications.scheduleNotification(
                withTitle: originalNotification.title,
                withBody:  originalNotification.body + " (snoozed \(NotificationViewController.retiesAmount) time)",
                withRequestID: Notifications.NotificationRequestIdentifier,
                withTimeInterval: time,
                withSound: originalNotification.sound != nil,
                repeating: false,
                withBadgeNumber: nil)
        }
    }
}
