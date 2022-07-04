//
//  SideMenuActions.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import Foundation
import SwiftUI


    func goingForShopping(roomData: Room, viewModel: AuthViewModel) {
        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,
                                                   "notification": [
                                                    "title":"Room: \(roomName)",
                                                    "body":"\(userName ?? "") is going for shopping.",
                                                    "badge": 1,
                                                    "sound":"default"]
                ]
                
                sendPushNotification(payloadDict: notifPayload)
            }
        }
    }

    func goingForLaundry(roomData: Room, viewModel: AuthViewModel) {
        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                 "body":"\(userName ?? "") is doing laundry.",
                                                                                 "badge": 1,
                                                                                 "sound":"default"]]
                sendPushNotification(payloadDict: notifPayload)
            }
        }
    }

    func fridgeIsFull(roomData: Room, viewModel: AuthViewModel) {
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                 "body":"Fridge is full. Please look into it.",
                                                                                 "badge": 1,
                                                                                 "sound":"default"]]
                sendPushNotification(payloadDict: notifPayload)
            }
        }
        
    }

    func cleanHouse(roomData: Room, viewModel: AuthViewModel) {
        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            
            
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                 "body":"\(userName ?? "") feels it's time to clean the house.",
                                                                                 "badge": 1,
                                                                                 "sound":"default"]]
                sendPushNotification(payloadDict: notifPayload)
            }
        }
        
        
    }



    
