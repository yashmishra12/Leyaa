//
//  PRCard.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/12/22.
//

import SwiftUI

struct PRCard: View {
    @State var itemName: String
    @State var timeStamp: String
    @State var id: String
    @ObservedObject var prManager: PRManager
    
    var body: some View {
        ZStack {
        
            
            VStack (spacing: 0){
                

                Image(itemName.sanitiseItemName()).resizable().frame(width: 60, height: 60)
                Text(itemName.capitalized).font(.body).fontWeight(.semibold).padding()
                Text(timeStamp).font(.caption)

                
            }
            

               // Delete Button
                VStack{
                    HStack{
                        Spacer()
                        Button {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.id])
                            prManager.updateArray(isDeleting: true)
                            prManager.prArray = prManager.prArray.filter { $0.id != self.id }

                        } label: {
                            Image(systemName: "x.circle").resizable().frame(width: 20, height: 20).padding()
                        }.buttonStyle(.plain)
                    }
                    Spacer()
                }
                
            
        

        }
        .foregroundColor(.white)
        .frame(minWidth: cardWidth, idealWidth: cardWidth, maxWidth: cardWidth, minHeight: 150, idealHeight: 150, maxHeight: 200 )
        .background(Color("MediumBlue"))
        
    }
}

struct PRCard_Previews: PreviewProvider {
    static var previews: some View {
        PRCard(itemName: "Coffee", timeStamp: "Jul 12, 2022 at 12:23 PM", id: "asdasd", prManager: PRManager())
    }
}
