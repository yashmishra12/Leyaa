//
//  PRCard.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/12/22.
//

import SwiftUI

struct PRCard: View {
    @State var itemName: String
    @State var roomName: String
    @State var timeStamp: String
    @State var id: String
    @State private var isDeleted: Bool = false
    var body: some View {
        VStack {
           
            if isDeleted == false {
                Text(roomName).font(.callout).fontWeight(.semibold)
                Text(itemName).font(.body).fontWeight(.semibold).padding()
                Text(timeStamp).font(.caption)
                Text("Long Press to Delete").font(.caption).fontWeight(.ultraLight).padding()
            }
            else {
                Text("Deleted").font(.title2).foregroundColor(.white)
            }
            
        }.frame(minWidth: cardWidth, idealWidth: cardWidth, maxWidth: cardWidth, minHeight: 195, idealHeight: 195, maxHeight: 195 )
            .background(isDeleted == false ? Color("MediumBlue") : Color("reject"))
            .onLongPressGesture {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.id])
                isDeleted = true
            }
    }
}

struct PRCard_Previews: PreviewProvider {
    static var previews: some View {
        PRCard(itemName: "Coffee", roomName: "Room name", timeStamp: "Jul 12, 2022 at 12:23 PM", id: "asdasd")
    }
}
