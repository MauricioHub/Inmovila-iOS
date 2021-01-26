//
//  CustomNotificationDelegate.swift
//  Vilanov
//
//  Created by andres on 4/19/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

//
//  SampleNotificationDelegate.swift
//  NotificationSample
//
//  Created by Lucas Goes Valle on 14/03/18.
//  Copyright © 2018 Lucas Goes Valle. All rights reserved.
//
import Foundation
import UserNotifications
import UserNotificationsUI

class SampleNotificationDelegate: NSObject , UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
}
