//
//  FreshCheckReminder.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/30/22.
//

import SwiftUI
import NotificationBannerSwift

struct FreshCheckReminder: View {
    @State private var itemName: String = ""
    @State var roomName: String
    
    @State private var isShowingCal: Bool = false
    @State private var selectedDate = Date()
    @State private var notificationPermitted: Bool = false

    
    func checkPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in

            if(settings.authorizationStatus == .authorized) {
                self.notificationPermitted = true
            } else {
                self.notificationPermitted = false
            }
        }
    }
    
    
    
    var body: some View {

        
        VStack{
            Image("reminder").resizable().aspectRatio(contentMode: .fit)

            
            VStack{
                CustomInputField(imageName: "hourglass", placeholderText: "Item Name", isSecureField: false, text: $itemName)
                    .padding()

                
                    DatePicker("Remind Me On:", selection: $selectedDate, in: Date()...).datePickerStyle(.compact)
                    .buttonStyle(.plain)
                    .padding(.bottom)
                    
                    Button {
                        CalendarTriggeredNotification(givenDate: selectedDate, roomName: roomName, itemName: itemName)
                        
                    } label: {
                        Text("Save").buttonStyle()
                    }.disabled(itemName.isEmpty || notificationPermitted == false)
                    .buttonStyle(.plain)
                    .padding(.top)
                
                if notificationPermitted == false {
                    Text("Notification is disabled").font(.caption)
                }
 
            }.padding()
            
            Spacer()

        }
        .onAppear(perform: {
            checkPermission()
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            NavigationLink {
                PendingReminderView(roomName: roomName)
            } label: {
                Image(systemName: "square.and.pencil").imageScale(.large)
            }.buttonStyle(.plain)

        }
    }
}


struct FreshCheckReminder_Previews: PreviewProvider {
    static var previews: some View {
        FreshCheckReminder(roomName: "Avent Ferry")
    }
}

