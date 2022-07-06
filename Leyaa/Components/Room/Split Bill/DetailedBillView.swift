//
//  DetailedBillView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/5/22.
//

import SwiftUI

struct DetailedBillView: View {
    @StateObject private var billManager = BillManager()
    @State var toPaybillArray: [Bill]
    @State var toGetbillArray: [Bill]
    @State var memberID: String
    @State var roomID: String
    
    var body: some View {
        VStack{
           
            VStack {
                if toPaybillArray.count > 0 {
                    Text("To Pay: ")
                }
            }
            
            VStack {
                if toGetbillArray.count > 0 {
                    Text("To Get: ")
                }
            }
            
            
        }
    }
}

//struct DetailedBillView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedBillView(toPaybillArray: [Bill(itemName: "Coffee", itemPrice: 40, payer: "adsad", contributor: "123ads", timestamp: Date())], memberID: "", roomID: "", toGetbillArray: [Bill(itemName: "Coffee", itemPrice: 40, payer: "adsad", contributor: "123ads", timestamp: Date())], memberID: "", roomID: "", memberID: "adasd", roomID: "213123")
//    }
//}
