//
//  ItemManager.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/14/22.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ItemManager {
    
    private var db = Firestore.firestore()
    
    
    //MARK: - ITEMS
    
    func addItem(item: [String : String], roomID: String ){
        
        db.collection("rooms").document(roomID).updateData(
            ["newItems" : Firebase.FieldValue.arrayUnion([item])]
        ) { err in
            if let err = err {  print("Error in adding item: \(err)") }
        }
        
        updateLastItemID(lastItemID: item["id"] ?? "", roomID: roomID)
        
    }
    
    
    func updateLastItemID(lastItemID: String, roomID: String) {
        db.collection("rooms").document(roomID).updateData(["lastItemID" : lastItemID]) { err in
            if let err = err {
                print("Error in updating last item id: \(err)")
            }
            
        }
    }
    
    func deleteItem(del: Item, roomID: String) {
        let itemDel: [String: String] = [
            "id": del.id,
            "name": del.name,
            "desc": del.desc,
            "qty": del.qty
        ]
        
        
        
        let docRef = db.collection("rooms").document(roomID)
        
        DispatchQueue.main.async {
            docRef.updateData([
                "newItems" : FieldValue.arrayRemove([itemDel]) ]){ err in
                    if let err = err {
                        print("Error in delete item: \(err)")
                    }
                }
        }
    }
    
    
    func editItem(item: Item, name: String, qty: String, desc: String, roomID: String) {
        
        let itemDel: [String: String] = [
            "id": item.id,
            "name": item.name,
            "desc": item.desc,
            "qty": item.qty
        ]
        
        let itemUpdate: [String: String] = [
            "id": UUID().uuidString,
            "name": name,
            "desc": desc,
            "qty": qty
        ]
        
        let docRef = db.collection("rooms").document(roomID)
        
        DispatchQueue.main.async {
            docRef.updateData(["newItems" : Firebase.FieldValue.arrayRemove([itemDel])]){ err in
                if let err = err {
                    print("Error in delete item with EDIT: \(err)")
                }
            }
            
            docRef.updateData(["newItems" : Firebase.FieldValue.arrayUnion([itemUpdate])]){ err in
                if let err = err {
                    print("Error in ADDING item with EDIT: \(err)")
                }
            }
        }
        
        updateLastItemID(lastItemID: itemUpdate["id"] ?? "", roomID: roomID)
        
        
    }
    
}
