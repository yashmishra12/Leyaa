import SwiftUI
import UIKit

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    @FocusState private var emailFocus: Bool
    @FocusState private var nameFocus: Bool
    @FocusState private var passFocus: Bool
    
    @State private var isContentViewPresented = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Navigation to ContentView using the new approach
                    Button("Proceed to ContentView") {
                        self.isContentViewPresented = true
                    }
                    .navigationDestination(isPresented: $isContentViewPresented) {
                        ContentView()
                    }
                    .hidden() // Hide this button if you do not wish it to be visible; navigation can be triggered programmatically
                    
                    // Your existing UI components
                    VStack {
                        AuthHeaderView(title1: "Get Started.").padding(.top)
                    }
                    
                    VStack(spacing: 40){
                        CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                            .keyboardType(.emailAddress)
                            .focused($emailFocus)
                            .onSubmit {
                                nameFocus = true
                            }
                            .submitLabel(.next)
                            
                        CustomInputField(imageName: "person", placeholderText: "Full Name", text: $fullname)
                            .focused($nameFocus)
                            .onSubmit {
                                passFocus = true
                            }
                            .submitLabel(.next)
                        
                        CustomInputField(imageName: "key", placeholderText: "Password", isSecureField: true, text: $password)
                            .focused($passFocus)
                            .onSubmit {
                                passFocus = false
                            }
                            .submitLabel(.done)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top)
                    
                    VStack {
                        Button {
                            viewModel.register(withEmail: email, password: password, fullname: fullname)
                        } label: {
                            Text("Sign Up").buttonStyleBlue()
                        }
                        .disabled(isValidEmail(email) == false)
                        .padding(.top, 10)
                        .buttonStyle(.plain)
                        .alert(isPresented: $viewModel.errorOccurred) {
                            Alert(title: Text("Invalid Credentials"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Text("Have an account?")
                                    .font(.footnote)
                                
                                Text("Sign In")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("MediumBlue"))
                            }
                        }
                    }.padding(.bottom, 30)
                        .buttonStyle(.plain)
                }
                .ignoresSafeArea()
                .navigationBarHidden(true)
            }
            .onTapGesture {
                self.endTextEditing()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AuthViewModel())
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
