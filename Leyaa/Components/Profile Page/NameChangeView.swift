//
//  NameChangeView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/16/22.
//

import SwiftUI


struct NameChangeView: View {
    @FocusState private var nameIsFocused: Bool
    @State var newName: String
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    func donePressed() {
        if newName.isEmpty == false {
            viewModel.nameChange(newName: newName)
            newName = ""
            successSB(title: "Name Saved")
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack {
            Image("changeName").resizable().frame(width: 300, height: 300, alignment: .center).aspectRatio(contentMode: .fit)
            
            CustomInputField(imageName: "person.fill", placeholderText: "New Name", isSecureField: false, text: $newName)
                .padding()
                .focused($nameIsFocused)
                .submitLabel(.done)
                .onSubmit {
                    donePressed()
                }

            Button {
                donePressed()
            } label: {
                Text("Save")
            }
            .buttonStyle(.plain)
            .buttonStyleBlue()
            .disabled(newName.isEmpty)
        }.padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.nameIsFocused = true
                }
            }
    }
}

struct NameChangeView_Previews: PreviewProvider {
    static var previews: some View {
        NameChangeView(newName: "Yash")
    }
}
