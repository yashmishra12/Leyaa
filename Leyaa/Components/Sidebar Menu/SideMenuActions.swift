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
                sendPayloadPush(token: token, roomName: roomName, body: "\(userName ?? "") is going for shopping.")
                
            }
        }
    }

    func goingForLaundry(roomData: Room, viewModel: AuthViewModel) {
        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            fetchDeviceToken(withUid: member) { token in
                    sendPayloadPush(token: token, roomName: roomName, body: "\(userName ?? "") is going to do laundry.")
            }
        }
    }

    func fridgeIsFull(roomData: Room, viewModel: AuthViewModel) {
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            
            fetchDeviceToken(withUid: member) { token in
                sendPayloadPush(token: token, roomName: roomName, body: "Fridge is full. Please look into it.")
            }
        }
        
    }

    func cleanHouse(roomData: Room, viewModel: AuthViewModel) {
        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            
            
            fetchDeviceToken(withUid: member) { token in
                sendPayloadPush(token: token, roomName: roomName, body: "\(userName ?? "") feels it's time to clean the house.")
            }
        }
        
        
    }



    
