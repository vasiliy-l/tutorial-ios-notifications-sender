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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showNotificationButtonPressed(_ sender: UIButton) {        
        appDelegate.notifications.scheduleNotification()
    }
    
}

