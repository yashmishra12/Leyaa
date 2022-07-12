//
//  PendingReminderView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/11/22.
//

import SwiftUI
import UserNotifications

struct PendingReminderView: View {
    
    @StateObject var prManager = PRManager()
    @State var roomName: String
    
    
    var body: some View {
        ScrollView {
            
            if prManager.prArray.isEmpty == false {
            LazyVGrid(columns: twoColumnGrid, alignment: .leading) {
                
                ForEach(prManager.prArray, id: \.id) { item in
                    VStack{
                        PRCard(itemName: item.body, roomName: item.subtitle, timeStamp: item.timestamp, id: item.id)

                    }.id(item.id)
                }
            }
            }
            else {
                VStack {
                              Text("No, reminder set.")
                                  .font(.title)
                                  .fontWeight(.bold)
                                  .kerning(1.2)
                                  .multilineTextAlignment(.center)
                                  .padding()
                              Spacer()
                              Image(relaxPic.randomElement() ?? "relax1").resizable().aspectRatio(contentMode: .fit).padding()
                              Spacer()
                          }
            }
        }.onAppear {
                prManager.roomName = roomName
                prManager.updateArray()
    
            }
        }

    }

struct PendingReminderView_Previews: PreviewProvider {
    static var previews: some View {
        PendingReminderView(roomName: "roomName")
    }
}
