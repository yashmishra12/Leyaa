//
//  MessageField.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/28/22.
//

import SwiftUI

struct MessageField: View {
    @EnvironmentObject var messagesManager: MessageManager
    @State private var message = ""
    @State var senderID: String
    @Binding var roomData: Room
    
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Type...").foregroundColor(.blue), text: $message).disableAutocorrection(true)
            
            Button {
                if message.isEmpty == false {
                    messagesManager.sendMessage(text: message, senderID: senderID)
                    message = ""
                }
         
                messagesManager.getMessages(roomID: roomData.id)
               
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(50)
            }.buttonStyle(.plain)

        }
        .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color("LightBlue"))
                .cornerRadius(50)
                .padding()
        
    
        
    }
}

//struct MessageField_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageField(senderID: senderID ).environmentObject(MessageManager())
//    }
//}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack (alignment: .leading) {
            if text.isEmpty {
                placeholder.opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).foregroundColor(.black).accentColor(.black)
        }
    }
}
