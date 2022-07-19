//
//  DeleteAccountData.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/17/22.
//

import SwiftUI

struct DeleteAccountData: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var wantToDelete: Bool = false
    var body: some View {
        VStack {
            Text("This will permanently delete your account. You will lose all your rooms, messages and item expiry reminders.\n\n\nTap on Confirm to continue.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                wantToDelete.toggle()
            } label: {
                Text("Confirm")
            }
            .DeleteAccountStyle()
            .buttonStyle(.plain)

        }           .confirmationDialog("Are you sure?",
                                        isPresented: $wantToDelete) {
                                        Button("Yes, delete my account.", role: .destructive) {
                                            viewModel.deleteAccountData()
                                            
                                          
                                        }
                                      } message: {
                                        Text("It breaks my heart to see you leave.")
                                      }
    }
}

struct DeleteAccountData_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountData()
    }
}
