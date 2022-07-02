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

func sendPushNotification(payloadDict: [String: Any]) {
    let serverKey: String = "AAAAWl5yGoA:APA91bF3eAohb9tcD5tk1a4sxjwJvk8kn0N0b6ETi-ShuUod73bmM2uWOlSQgLn9x-4kUJTtJ9kDvYdwzM42Ehxuw12aGXUmjF8zAsNez13eidYvItMN23afUvbrC0JIpXacJndMc7kw"
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
