//
//  FreshCheckReminder.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/30/22.
//

import SwiftUI
import UserNotifications

struct FreshCheckReminder: View {
    @State private var itemName: String = ""
    @State private var timeToCheck: Int = 1
    @Binding var roomName: String 
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack{
            Text("Set a reminder to check on a product.").font(.callout)
                .padding(.top, 30)
                .padding(.bottom, screenHeight*0.2)
            
           
            VStack{
                
                CustomInputField(imageName: "hourglass", placeholderText: "Item Name", isSecureField: false, text: $itemName)
                    .padding()

                Stepper("\(timeToCheck) day", value: $timeToCheck, in: 1...365).padding()
                    .frame (width: screenWidth * 0.5)
                
                Button {
                    let content = UNMutableNotificationContent()
                    content.title = "Freshness Check."
                    content.subtitle = "Room: \(roomName). Check on \(itemName)"
                    content.sound = UNNotificationSound.default
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timeToCheck)*86400.0, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request)
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("Save")
                        .font (.headline)
                        .foregroundColor (.white)
                        .frame (width: screenWidth * 0.7, height: 40)
                        .background(Color("MediumBlue"))
                        .clipShape(Capsule())
                        .padding ()
                        .padding(.top, 15)
                }.disabled(itemName.isEmpty)
                .buttonStyle(.plain)
            }.padding()
            
            Spacer()

        }
        
    }
}

struct FreshCheckReminder_Previews: PreviewProvider {
    static var previews: some View {
        FreshCheckReminder(roomName: .constant("Avent Ferry"))
    }
}

