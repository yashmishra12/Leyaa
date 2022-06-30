//
//  AppDelegateAdapter.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/29/22.
//

import Foundation
import Firebase
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
