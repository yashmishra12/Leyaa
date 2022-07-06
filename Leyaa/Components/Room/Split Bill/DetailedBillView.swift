//
//  DetailedBillView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/5/22.
//

import SwiftUI

struct DetailedBillView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @StateObject private var billManager = BillManager()
    @State var memberID: String
    @State var roomID: String
    @State var roomName: String 
    @State var isShowingGet: Bool = true
    @State var isShowingPay: Bool = true
    @State var memberName: String
    
    
    
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            isShowingPay = true
                            isShowingGet = true
                        }
                    } label: {
                        Text("All").payTabStyle()
                    }.buttonStyle(.plain)
                    
                    Button {
                        withAnimation(.spring()) {
                        isShowingPay = true
                        isShowingGet = false
                        }
                    } label: {
                        Text("Pay").payTabStyle()
                    }.buttonStyle(.plain)
                    
                    
                    Button {
                        withAnimation(.spring()) {
                        isShowingPay = false
                        isShowingGet = true
                        }
                    } label: {
                        Text("Get").payTabStyle()
                    }.buttonStyle(.plain)
                    
                    

                }
                
                Spacer()
                
                VStack {
                    if billManager.toPaybills.count > 0 {
                        HStack {
                            Text("To Pay: ").font(.body).fontWeight(.semibold)
                                .padding()
                            
                            // To Pay Chevron
                            Button {
                                withAnimation(.easeInOut) {
                                    isShowingPay.toggle()
                                }
                            } label: {
                                if isShowingPay {
                                    Image(systemName: "chevron.down.circle").resizable().frame(width: 20, height: 20).padding(.leading, -5)
                                }else {
                                    Image(systemName: "chevron.up.circle").resizable().frame(width: 20, height: 20).padding(.leading, -5)
                                }
                            }.buttonStyle(.plain)

                            Spacer()
                            
                            // Name and Notification
                            HStack {
                                Text(memberName).font(.caption2).padding(.trailing, 15)
                                
                                //Notification Button
                                Button {
                                    viewModel.getDeviceToken(userID: memberID) { token in
                                        let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                                         "body":"\(viewModel.currentUser?.fullname ?? "") has paid.",
                                                                                                         "badge": 1,
                                                                                                         "sound":"default"]]
                                        
                                        sendPushNotification(payloadDict: notifPayload)
                                    }
                                } label: {
                                    HStack{
                                        Image(systemName: "bell.square.fill").imageScale(.large)
                                        Text("Paid").font(.caption2).padding(.trailing, 10)
                                    }
                                }.buttonStyle(.plain)
                            }

                        }
                        
                        if isShowingPay {
                            LazyVGrid(columns: twoColumnGrid, alignment: .center) {
                                ForEach(billManager.toPaybills, id:\.self) { bill in
                                    UnitBill(billTitle: bill.itemName,
                                             billAmount: bill.itemPrice,
                                             timestamp: bill.timestamp,
                                             id: bill.id ?? "", roomID: roomID)
                                        .frame(width: screenWidth*0.5)
                                        .background(Color("MediumBlue"))
                                        .foregroundColor(.white)
                                        
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    if billManager.toGetbills.count > 0 {
                        HStack{
                            
                            Text("To Get: ").font(.body).fontWeight(.semibold).padding()
                            Button {
                                withAnimation(.easeInOut) {
                                    isShowingGet.toggle()
                                }
                            } label: {
                                if isShowingGet {
                                    Image(systemName: "chevron.down.circle").resizable().frame(width: 20, height: 20)
                                }else {
                                    Image(systemName: "chevron.up.circle").resizable().frame(width: 20, height: 20)
                                }
                            }.buttonStyle(.plain)
                            
                            Spacer()
                            
                            Text(memberName).font(.caption2).padding(.trailing, 15)
                            
                            Button {
                                viewModel.getDeviceToken(userID: memberID) { token in
                                    let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                                     "body":"\(viewModel.currentUser?.fullname ?? "") has paid.",
                                                                                                     "badge": 1,
                                                                                                     "sound":"default"]]
                                    
                                    sendPushNotification(payloadDict: notifPayload)
                                }
                            } label: {
                                HStack{
                                    Image(systemName: "bell.square.fill").imageScale(.large)
                                    Text("Ask").font(.caption2).padding(.trailing, 10)
                                }
                            }.buttonStyle(.plain)
                            
                        }
                       
                        if isShowingGet {
                            LazyVGrid(columns: twoColumnGrid, alignment: .leading) {
                                ForEach(billManager.toGetbills, id:\.self) { bill in
                                    UnitBill(billTitle: bill.itemName,
                                             billAmount: bill.itemPrice,
                                             timestamp: bill.timestamp,
                                             id: bill.id ?? "",
                                             roomID: roomID)
                                        .background(Color("MediumBlue"))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getProfileName(userID: memberID) { name in self.memberName = name }
            billManager.updateRoomID(name: roomID)
            billManager.updateToGet(contributorID: memberID)
            billManager.updateToPay(contributorID: memberID)
        }
    }
}

struct DetailedBillView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedBillView( memberID: "adasd", roomID: "213123", roomName: "RoomName", memberName: "ABC").environmentObject(AuthViewModel())
    }
}
