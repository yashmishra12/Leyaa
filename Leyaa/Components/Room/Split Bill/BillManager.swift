//
//  BillManager.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/5/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class BillManager: ObservableObject {

    @Published var roomID: String
    @Published var totalAmount: Double = 0
   
    @Published private(set) var toGetbills: [Bill] = []
    @Published var toGetAmount: Double = 0
    
    @Published private(set) var toPaybills: [Bill] = []
    @Published var toPayAmount: Double = 0
    
    
    
    init(name: String? = nil) {
        if let name = name {
            roomID = name
        } else {
            roomID = ""
        }
    }
    
    func updateRoomID(name: String) {
        roomID = name
        self.totalAmount = 0
    }
    
    
    
    let db = Firestore.firestore()

    func updateToGet(contributorID: String) {
        let collectionName = "\(roomID)_BILLS"
        
        db.collection(collectionName)
            .whereField("payer", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .whereField("contributor", isEqualTo: contributorID)
            .addSnapshotListener { snapshot, error in
                
                self.toGetAmount = 0
                    
                    guard let doc = snapshot?.documents else {
                        print("No Doc Found")
                        return
                    }
                    
                DispatchQueue.main.async {
                    self.toGetbills = doc.compactMap { queryDocumentSnapshot -> Bill? in
                        let result = Result { try queryDocumentSnapshot.data(as: Bill.self) }
                        
                        switch result {
                        case .success(let bill):
                            self.toGetAmount += bill.itemPrice
                            self.totalAmount += bill.itemPrice
                            return bill
                            
                        case .failure( _):
                            print("Failure To Get Bill Request")
                            return nil
                        }
                        
                    }
                }
                self.toGetbills.sort { $0.timestamp > $1.timestamp }
            }

        
    }
    
    
    func updateToPay(contributorID: String) {
        let collectionName = "\(roomID)_BILLS"
        
        db.collection(collectionName)
            .whereField("payer", isEqualTo: contributorID)
            .whereField("contributor", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .addSnapshotListener { snapshot, error in
               
                self.toPayAmount = 0
                
                    guard let doc = snapshot?.documents else {
                        print("No Doc Found")
                        return
                    }
                    
                DispatchQueue.main.async {
                    self.toPaybills = doc.compactMap { queryDocumentSnapshot in
                        let result = Result { try queryDocumentSnapshot.data(as: Bill.self) }
                        
                        switch result {
                        case .success(let bill):
                            self.toPayAmount += bill.itemPrice
                            self.totalAmount -= bill.itemPrice
                            return bill
                            
                        case .failure( _):
                            print("Failure To Pay Bill Request")
                            return nil
                        }
                    }
                }
                
                self.toPaybills.sort { $0.timestamp > $1.timestamp }
            }
        
    }
    
    

    

    


}
