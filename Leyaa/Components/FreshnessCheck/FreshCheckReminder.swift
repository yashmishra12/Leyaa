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
    
    @State private var selectedDate = Date()+60
    @State private var notificationPermitted: Bool = false

    @StateObject var prManager = PRManager()
    @FocusState private var itemNameIsFocused: Bool
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    func donePressed() {
        if itemName.isEmpty == false {
            CalendarTriggeredNotification(givenDate: selectedDate, itemName: itemName)
            itemName = ""
            prManager.updateArray(isDeleting: false)
            selectedDate = Date()+60
        }
    }
    
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
            
            VStack{
                Text("Set Reminder for Item Expiry").font(.callout).fontWeight(.medium).multilineTextAlignment(.center)
                
                CustomInputField(imageName: "leaf.fill", placeholderText: "Item Name", isSecureField: false, text: $itemName)
                    .submitLabel(.done)
                    .focused($itemNameIsFocused)
                    .onSubmit {
                        donePressed()
                    }
                    .padding()
                

                
                    DatePicker("Remind Me On:", selection: $selectedDate, in: (Date()+60)...).datePickerStyle(.compact)
                    .buttonStyle(.plain)
                    .padding(.bottom)
                    
                    Button {
                       donePressed()
                        
                    } label: {
                        Text("Save").buttonStyleBlue()
                    }.disabled(itemName.isEmpty || notificationPermitted == false)
                    .buttonStyle(.plain)
                    .padding(.top)
                
                if notificationPermitted == false {
                    Text("Notification is disabled").font(.caption)
                }
 
            }.padding()
 
            
            Divider().padding(.bottom)
            
            VStack {
                if prManager.prArray.isEmpty==false {
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            
                            LazyVGrid(columns: twoColumnGrid, alignment: .leading) {
                                
                                ForEach(prManager.prArray, id: \.id) { item in

                                    VStack {
                                        PRCard(itemName: item.body,
                                               timeStamp: item.timestamp,
                                               id: item.id,
                                               prManager: prManager)
                                        .padding(.bottom, -3)
                                        }.id(item.id)
                                    }
                                }
                            }
                        .onChange(of: prManager.lastItemID) { id in
                            withAnimation(.easeInOut) { proxy.scrollTo(id, anchor: .bottom) }
                        }
                        .onAppear(perform: {
                            withAnimation(.easeInOut) {
                                proxy.scrollTo( prManager.lastItemID, anchor: .bottom)
                            }
                        })
                    }
                    
                }
                else {
                    Image("waiting").resizable().aspectRatio(contentMode: .fit).padding()
                }
  
                    }
   
        }
        .onAppear(perform: {
            checkPermission()
            prManager.updateArray(isDeleting: false)
        })
        .padding(.bottom)
            
            

        } //END of Body
   
    }



struct FreshCheckReminder_Previews: PreviewProvider {
    static var previews: some View {
        FreshCheckReminder()
    }
}

