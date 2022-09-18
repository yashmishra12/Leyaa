//
//  payloadNotification.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/11/22.
//

import Foundation

func sendPayloadPush(token: String, roomName: String, body: String) {
    
    let notifPayload: [String: Any] = ["to": token ,
                                       "notification": [  "title":"Room: \(roomName)",
                                                           "body": body,
                                                           "badge": 1,
                                                           "sound":"default"]
                                        ]

    sendPushNotification(payloadDict: notifPayload)
}


func roomJoinRequestPayload(token: String, body: String) {
    
    let notifPayload: [String: Any] = [ "to": token ,
                                        "notification": [
                                            "title":"Room Join Request",
                                            "body": body,
                                            "sound":"default" ]
                                      ]
    
    sendPushNotification(payloadDict: notifPayload)
}
