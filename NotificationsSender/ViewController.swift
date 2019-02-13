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
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var notificationTimeField: UITextField!
    @IBOutlet var withSoundSwitch: UISwitch!
    @IBOutlet var repeatSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Notifications
    
    @IBAction func scheduleNotificationButtonPressed(_ sender: UIButton) {
        guard let timeString = notificationTimeField.text,
              let timeInterval = Double.init(timeString) else {
                print("Unable to parse time interval value, notification is not scheduled!")
                return
        }
        
        appDelegate.notifications.scheduleNotification(
            withTitle: "Time Interval Notification",
            withBody: "Just wanna say hello to you!",
            withRequestID: Notifications.NotificationRequestIdentifier,
            withTimeInterval: timeInterval,
            withSound: withSoundSwitch.isOn,
            repeating: repeatSwitch.isOn,
            withBadgeNumber: nil)
    }
    
    @IBAction func clearNotificationButtonPressed(_ sender: UIButton) {
        appDelegate.notifications.unscheduleNotification(withRequestID: Notifications.NotificationRequestIdentifier)
        
        notificationTimeField.text = "20"
        withSoundSwitch.isOn = false
        repeatSwitch.isOn = false
    }
    
    /**
     Repeating notification cannot be scheduled with time interval less than 60 seconds,
     so we need to check and undate Time Interval field value accordingly.
    */
    @IBAction func repeatSwitchUpdated(_ sender: UISwitch) {
        // Try to parse Time Interval field value
        var timeInterval: Double?
        if let timeString = notificationTimeField.text {
            timeInterval = Double.init(timeString)
        }
        
        // If Repeat option is enabled, Notification Time must be at least 60 seconds.
        if (sender.isOn && (timeInterval == nil || timeInterval! < 60.0) ) {
            notificationTimeField.text = "60"
        }
    }
    
    
    // MARK: - Application badge
    
    @IBAction func increaseBadgeNumberButtonPressed(_ sender: UIButton) {
        let nextBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        appDelegate.notifications.scheduleNotification(
            withTitle: "Notification with badge",
            withBody: "+1 to application badge value. Check it!",
            withRequestID: Notifications.BadgeNotificationRequestIdentifier,
            withTimeInterval: 5,
            withSound: false,
            repeating: false,
            withBadgeNumber: nextBadgeNumber)
    }
    
    @IBAction func clearBadgeNumberButtonPressed(_ sender: UIButton) {
        appDelegate.notifications.unscheduleNotification(withRequestID: Notifications.BadgeNotificationRequestIdentifier)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

