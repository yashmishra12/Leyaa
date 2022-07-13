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
        ZStack {
            VStack {
                    ScrollView {
                        
                        if prManager.prArray.isEmpty == false {
                        LazyVGrid(columns: twoColumnGrid, alignment: .leading) {
                            
                            ForEach(prManager.prArray, id: \.id) { item in

                                    PRCard(itemName: item.body,
                                           timeStamp: item.timestamp,
                                           id: item.id,
                                           prManager: prManager)
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
                    }
                    
                
            }.onAppear {
                prManager.updateArray(isDeleting: false)
            }

        }
        .navigationTitle("Reminders")
        }

    }

struct PendingReminderView_Previews: PreviewProvider {
    static var previews: some View {
        PendingReminderView(roomName: "roomName")
    }
}
