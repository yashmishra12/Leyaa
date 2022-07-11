//
//  Bill.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import UIKit

struct Bill: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let itemName: String
    let itemPrice: Double
    let payer: String
    let contributor: String
    let timestamp: Date
}
