//
//  PopulateRoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/16/22.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth


class PopulateRoomView: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?

}
