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
            print("Snooze for 3 secs selected, re-schedule notification")
            
            // TODO: - move to some shared library?
            let notificationCenter = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Hello again!"
            content.body = ":D"
            content.categoryIdentifier = "MY_NOTIFICATION_CATEGORY"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: "REPEATED_NOTIFY", content: content, trigger: trigger)
            
            notificationCenter.add(request) { (error) in
                if error != nil {
                    print("Unable to re-schedule notification!")
                    print(error!.localizedDescription)
                }
            }
            
            completion(.dismiss)
        case "SNOOZE_1MIN":
            print("Snooze for 1 minute selected")
            completion(.dismiss)
        case "SNOOZE_2MIN":
            print("Snooze for 2 minutes selected")
            completion(.dismiss)
        
        default:
            dismissNotification()
            
        }
    }
    
    func showSnoozeActions() {
        let actions = [
            UNNotificationAction(identifier: "SNOOZE_3SEC", title: "Snooze for 3 secs", options: []),
            UNNotificationAction(identifier: "SNOOZE_1MIN", title: "Snooze for 1 min", options: []),
            UNNotificationAction(identifier: "SNOOZE_2MIN", title: "Snooze for 2 mins", options: []),
            ]
        extensionContext?.notificationActions = actions
    }
}
