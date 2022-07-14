//
//  PushNotificationService.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/1/22.
//

import Foundation
import Firebase
import FirebaseService
import FirebaseFirestoreSwift
import UserNotifications

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
        _ = String(data: data, encoding: .utf8)
    }
    task.resume()
}


func fetchDeviceToken(withUid uid: String, completion: @escaping(String) -> Void) {
    Firestore.firestore().collection("users").document(uid)
        .getDocument { document, error in
            if let document = document, document.exists {
                let property = document.get("deviceToken") as! String
                completion(property)
            }
        }
}

func fetchDeviceTokenFromEmail(email: String, completion: @escaping(String) -> Void) {
    let docRef = Firestore.firestore().collection("users").whereField("email", isEqualTo: email).limit(to: 1)
    docRef.getDocuments  { (querySnapshot, err) in
        if let err = err {
                    print("Error getting documents -- fetchDeviceTokenFromEmail: \(err)")
                    return
                }
        if let snap = querySnapshot {
                     for document in snap.documents {
                         let property = document.get("deviceToken") as! String
                         completion(property)
                     }
             } else {
                 print("no data returned")
             }
    }
}

// Freshness Reminder

func CalendarTriggeredNotification(givenDate: Date, itemName: String) {
    let content = UNMutableNotificationContent()
    content.title = "Freshness Check"
    
    content.body = "\(itemName)"
    
    content.sound = UNNotificationSound.default
    
    let dateComponent = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: givenDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
    
  
    
    successSB(title: "Reminder Saved")
}




