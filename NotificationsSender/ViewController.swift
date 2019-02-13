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
    
    @IBAction func scheduleNotificationButtonPressed(_ sender: UIButton) {
        guard let timeString = notificationTimeField.text,
              let timeInterval = Double.init(timeString) else {
                print("Unable to parse time interval value, notification is not scheduled!")
                return
        }
        
        appDelegate.notifications.scheduleNotification(withTimeInterval: timeInterval, withSound: withSoundSwitch.isOn, repeating: repeatSwitch.isOn)
    }
    
    @IBAction func clearNotificationButtonPressed(_ sender: UIButton) {
        appDelegate.notifications.unscheduleNotification()
        
        notificationTimeField.text = "20"
        withSoundSwitch.isOn = false
        repeatSwitch.isOn = false
    }
    
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
    
}

extension ViewController {
    

}

