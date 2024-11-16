//
//  PushNotificationService.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/1/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import UserNotifications
import SwiftJWT

func getAccessToken(completion: @escaping (String?) -> Void) {
//    let jsonKeyFilePath = "leyaa-7b042-1fe484a10012.json" // Replace with your JSON key file path
    guard let jsonKeyFilePath = Bundle.main.path(forResource: "leyaa-7b042-1fe484a10012", ofType: "json") else {
        print("Failed to find the JSON key file")
        completion(nil)
        return
    }

    
    // Load Service Account JSON Key
    guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonKeyFilePath)),
          let keyData = try? JSONDecoder().decode(ServiceAccountKey.self, from: jsonData) else {
        print("Failed to load or parse service account key file")
        completion(nil)
        return
    }

    // Define JWT Claims
    struct FirebaseClaims: Claims {
        let iss: String // Issuer: service account email
        let scope: String // Required scope for FCM
        let aud: String // Audience: OAuth token URL
        let iat: Date // Issued at
        let exp: Date // Expiry
    }

    // Create JWT Header and Claims
    let claims = FirebaseClaims(
        iss: keyData.clientEmail,
        scope: "https://www.googleapis.com/auth/firebase.messaging",
        aud: "https://oauth2.googleapis.com/token",
        iat: Date(),
        exp: Date().addingTimeInterval(3600) // Token valid for 1 hour
    )
    var jwt = JWT(claims: claims)

    // Sign the JWT with the private key
    guard let privateKey = keyData.privateKey.data(using: .utf8) else {
        print("Failed to parse private key")
        completion(nil)
        return
    }

    let jwtSigner = JWTSigner.rs256(privateKey: privateKey)
    guard let signedJWT = try? jwt.sign(using: jwtSigner) else {
        print("Failed to sign JWT")
        completion(nil)
        return
    }

    // Exchange the JWT for an OAuth 2.0 Bearer Token
    var request = URLRequest(url: URL(string: "https://oauth2.googleapis.com/token")!)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(signedJWT)".data(using: .utf8)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching access token: \(error)")
            completion(nil)
            return
        }

        guard let data = data,
              let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let accessToken = responseJSON["access_token"] as? String else {
            print("Failed to parse access token response")
            completion(nil)
            return
        }

        completion(accessToken)
    }

    task.resume()
}

// Helper Structs for Parsing JSON Key
struct ServiceAccountKey: Codable {
    let privateKey: String
    let clientEmail: String

    enum CodingKeys: String, CodingKey {
        case privateKey = "private_key"
        case clientEmail = "client_email"
    }
}

func sendPushNotificationWithDebugging(payload: [String: Any]) {
    let url = URL(string: "https://fcm.googleapis.com/v1/projects/leyaa-7b042/messages:send")!
    
    getAccessToken { token in
        guard let token = token else {
            print("Failed to retrieve access token")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending push notification: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Notification send failed with status: \(httpResponse.statusCode)")
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseBody)")
                }
            } else {
                print("Notification sent successfully")
            }
        }

        task.resume()
    }
}



func sendPushNotification(payloadDict: [String: Any]) {
    let url = URL(string: "https://fcm.googleapis.com/v1/projects/leyaa-7b042/messages:send")!
    
    getAccessToken { token in
        guard let token = token else {
            print("Failed to retrieve access token")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payloadDict, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending push notification: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Notification send failed with status: \(httpResponse.statusCode)")
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseBody)")
                }
            } else {
                print("Notification sent successfully")
            }
        }

        task.resume()
    }
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




