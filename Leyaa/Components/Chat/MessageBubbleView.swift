//
//  MessageBubbleView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/28/22.
//

import SwiftUI

struct MessageBubbleView: View {
    @State var message: Message
    @State var roomID: String
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showTime: Bool = false
    @State var avatar = "ketchup"
    @State var name = ""
    
    
    var body: some View {

        VStack (alignment: message.senderID == viewModel.currentUser?.id ? .trailing : .leading) {

                HStack {
                    if(message.senderID != viewModel.currentUser?.id) {
                        VStack {
                            Image(avatar).resizable().frame(width: 50, height: 50, alignment: message.senderID == viewModel.currentUser?.id ? .trailing : .leading)
                            Text(name).font(.caption2).foregroundColor(.green)
                        }
                    }
                    
                    
                    //change background
                    Text(message.text).font(.footnote).padding()
                        .background(message.senderID == viewModel.currentUser?.id ? Color("myMsg") : Color("otherMsg"))
                        .foregroundColor(Color("chatFont")).cornerRadius(30)
                    
                    
                    if(message.senderID == viewModel.currentUser?.id) {
                        VStack {
                            Image(avatar).resizable().frame(width: 50, height: 50, alignment: message.senderID == viewModel.currentUser?.id ? .trailing : .leading)
                            Text(name).font(.caption2).foregroundColor(.blue)
                        }
                    }

                }
                .frame(maxWidth: screenWidth, alignment: message.senderID == viewModel.currentUser?.id ? .trailing : .leading).padding()
                .onTapGesture {showTime.toggle()}
                
                HStack{
                    if showTime && message.senderID == viewModel.currentUser?.id {
                        Spacer()
                        Text("\(message.timestamp.formatted(.dateTime.day().month().hour().minute()))")
                            .fontWeight(.ultraLight).font(.caption2)
                    }
                    
                    if showTime && message.senderID != viewModel.currentUser?.id {
                       
                        Text("\(message.timestamp.formatted(.dateTime.day().month().hour().minute()))")
                            .fontWeight(.ultraLight).font(.caption2)
                        Spacer()
                    }
                }.padding(.horizontal, 40)
                    .padding(.top, -20)

            }.frame(width: screenWidth, alignment: message.senderID == viewModel.currentUser?.id ? .trailing : .leading)
                .onAppear {
                    viewModel.getProfileAvatar(userID: message.senderID) { res in avatar = res }
                    viewModel.getProfileName(userID: message.senderID) { res in name = res  }
            }
        
            
    }
}
//
//struct MessageBubbleView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageBubbleView(message: Message(id: "asdasd", text: "Hi, How's it going? gadaai.", senderID: "King", senderName: "Yash Mishra", senderAvatar: "coffee", timestamp: Date() )).preferredColorScheme(.dark).previewLayout(.sizeThatFits)
//    }
//}
