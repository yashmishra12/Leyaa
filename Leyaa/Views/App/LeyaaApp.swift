//
//  LeyaaApp.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI
import Firebase
import UserNotifications
import FirebaseMessaging

@main
struct LeyaaApp: App {
    @StateObject var viewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Reset badge count on launch
        UIApplication.shared.applicationIconBadgeNumber = 0

        // Set Firebase Messaging Delegate
        Messaging.messaging().delegate = self

        // Request notification permissions
        if #available(iOS 10.0, *) {
            // For iOS 10+ devices
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
                if let error = error {
                    print("Notification permissions error: \(error)")
                }
            }
        } else {
            // For older iOS versions
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Reset badge count when app becomes active
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("Badge count reset to 0")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle received notification
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Increment badge count
        UIApplication.shared.applicationIconBadgeNumber += 1
        print("Badge count incremented to: \(UIApplication.shared.applicationIconBadgeNumber)")

        print("Notification payload: \(userInfo)")
        completionHandler(.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Save the FCM token
        let deviceToken: [String: String] = ["token": fcmToken ?? ""]
        UserDefaults.standard.set(deviceToken["token"], forKey: "deviceTokenStorage")
        print("FCM Token: \(fcmToken ?? "")")
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Increment badge count
        UIApplication.shared.applicationIconBadgeNumber += 1
        print("Badge count incremented to: \(UIApplication.shared.applicationIconBadgeNumber)")

        print("Notification payload: \(userInfo)")

        // Display the notification as a banner, badge, and sound
        completionHandler([[.banner, .badge, .sound]])
    }

    // Handle notification response when the app is in background or terminated
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        print("Notification response payload: \(userInfo)")
        completionHandler()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Process device token if needed
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}
