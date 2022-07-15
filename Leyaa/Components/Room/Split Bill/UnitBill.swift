//
//  UnitBill.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/5/22.
//

import SwiftUI

struct UnitBill: View {

    @State var billTitle: String
    @State var billAmount: Double
    @State var timestamp: Date
    @State var id: String
    @State var roomID: String
    let billManager = BillManager()
    
    var body: some View {
        VStack{
            Text(billTitle).font(.headline).fontWeight(.semibold).padding()
            Text("$: \(String(format: "%.2f", billAmount))").font(.body)
            Text("\(timestamp.formatted(.dateTime.day().month().hour().minute()))").fontWeight(.light).font(.caption).padding()
        }.padding()
            .frame(width: cardWidth, height: 195, alignment: .center)
            .onLongPressGesture {
                withAnimation {
                    billManager.deleteBill(roomID: roomID, docID: id)
                }
            }
    }
}


struct UnitBill_Previews: PreviewProvider {
    static var previews: some View {
        UnitBill(billTitle: "", billAmount: 2, timestamp: Date(), id: "asdasd", roomID: "123")
    }
}
