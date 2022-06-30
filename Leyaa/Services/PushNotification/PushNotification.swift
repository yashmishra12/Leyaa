//
//  PushNotification.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/30/22.
//

import Foundation
import SwiftUI

struct PushNotification {
    @EnvironmentObject var viewModel: AuthViewModel
    
    let serverKey: String = "AAAAWl5yGoA:APA91bF3eAohb9tcD5tk1a4sxjwJvk8kn0N0b6ETi-ShuUod73bmM2uWOlSQgLn9x-4kUJTtJ9kDvYdwzM42Ehxuw12aGXUmjF8zAsNez13eidYvItMN23afUvbrC0JIpXacJndMc7kw"
    
    func sendPushNotification(payloadDict: [String: Any]) {
       let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
       var request = URLRequest(url: url)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
       request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payloadDict, options: [.prettyPrinted])
       let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data, error == nil else {
            print(error ?? "")
            return
          }
          if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print(response ?? "")
          }
          print("Notfication sent successfully.")
          let responseString = String(data: data, encoding: .utf8)
          print(responseString ?? "")
       }
       task.resume()
    }
    
    func goingForShopping(members: [String], roomName: String) {
        let userName = viewModel.currentUser?.fullname
        
        
        for val in members where val != UserDefaults.standard.string(forKey: "kDevice") {
            let notifPayload: [String: Any] = ["to": val,"notification": ["title":"\(roomName)",
                                                                          "body":"\(userName ?? "") is going shopping.",
                                                                          "sound":"default"]]
            self.sendPushNotification(payloadDict: notifPayload)
        }
    }
    
    
    
}





//sendPushNotification(payloadDict: notifPayload)

