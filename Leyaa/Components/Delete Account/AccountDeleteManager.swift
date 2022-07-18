//
//  AccountDeleteManager.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/17/22.
//

import Foundation
import SwiftUI

class AccountDeleteManager: ObservableObject {
    @Published var isAppleAuthRevoked: Bool = false
    
    
    func revoked() {
        DispatchQueue.main.async {
            self.isAppleAuthRevoked = true
        }
    }
    
}
