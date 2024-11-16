//
//  payloadNotification.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/11/22.
//

import Foundation
import UIKit

func sendPayloadPush(token: String, roomName: String, body: String) {
    let notifPayload: [String: Any] = [
        "message": [
            "token": token, // The device's FCM registration token
            "notification": [
                "title": "Room: \(roomName)",
                "body": body
            ],
            "apns": [
                "payload": [
                    "aps": [
                        "badge": UIApplication.shared.applicationIconBadgeNumber + 1,
                        "sound": "default"
                    ]
                ]
            ]
        ]
    ]


    sendPushNotification(payloadDict: notifPayload)
}



func roomJoinRequestPayload(token: String, body: String) {
    let notifPayload: [String: Any] = [
        "message": [
            "token": token, // The device's FCM registration token
            "notification": [
                "title": "Room Join Request",
                "body": body
            ],
            "apns": [
                "payload": [
                    "aps": [
                        "badge": UIApplication.shared.applicationIconBadgeNumber + 1, // Set the badge count
                        "sound": "default" // Set the notification sound
                    ]
                ]
            ]
        ]
    ]

    sendPushNotification(payloadDict: notifPayload)
}

