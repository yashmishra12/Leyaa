//
//  NameChangeView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/16/22.
//

import SwiftUI


struct NameChangeView: View {
    @FocusState private var nameIsFocused: Bool
    @State private var newName: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("changeName").resizable().frame(width: 300, height: 300, alignment: .center).aspectRatio(contentMode: .fit)
            
            CustomInputField(imageName: "person.fill", placeholderText: "New Name", isSecureField: false, text: $newName)
                .padding()
                .focused($nameIsFocused)
            

            Button {
                viewModel.nameChange(newName: newName)
                newName = ""
                successSB(title: "Name Saved")
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .buttonStyle(.plain)
            .buttonStyle()
            .disabled(newName.isEmpty)

            
        }.padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                    self.nameIsFocused = true
                }
            }
    }
}

struct NameChangeView_Previews: PreviewProvider {
    static var previews: some View {
        NameChangeView()
    }
}
