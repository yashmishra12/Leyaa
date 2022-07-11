//
//  FreshCheckReminder.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/30/22.
//

import SwiftUI
import UserNotifications
import NotificationBannerSwift

struct FreshCheckReminder: View {
    @State private var itemName: String = ""
    @Binding var roomName: String 
    @Environment(\.presentationMode) var presentationMode
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
    
    func CalendarTriggeredNotification(givenDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Freshness Check."
        content.subtitle = "Room: \(roomName). Check on \(itemName)"
        content.sound = UNNotificationSound.default
        
        let dateComponent = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: givenDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        successNB(title: "Reminder Saved")
        
        presentationMode.wrappedValue.dismiss()
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
                            CalendarTriggeredNotification(givenDate: selectedDate)
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
        
    }
}


struct FreshCheckReminder_Previews: PreviewProvider {
    static var previews: some View {
        FreshCheckReminder(roomName: .constant("Avent Ferry"))
    }
}

