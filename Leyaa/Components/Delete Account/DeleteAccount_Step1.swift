import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import Firebase

struct DeleteAccount_Step1: View {
    @State private var currentNonce: String?
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var goToInstructionPage: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("dontGo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .padding(.top, -30)
                
                Text("If you created your account with Apple, Sign-in again with Apple to revoke apple token and then you can remove your account and all its data.")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding()
                
                Text("\nIf you haven't used Apple Sign-in, tap on 'Normal Sign-Up'")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                VStack {
                    SignInWithAppleButton(
                        onRequest: { request in
                            let nonce = randomNonceString()
                            currentNonce = nonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = sha256(nonce)
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                switch authResults.credential {
                                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                    
                                    guard let nonce = currentNonce, let appleIDToken = appleIDCredential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                    }
                                    
                                    UserDefaults.standard.set(appleIDCredential.user, forKey: "userID")
                                    
                                    // Process authorization code and obtain refresh token
                                    if let authorizationCode = appleIDCredential.authorizationCode, let codeString = String(data: authorizationCode, encoding: .utf8) {
                                        let url = URL(string: "https://us-central1-leyaa-7b042.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
                                        
                                        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                                            if let data = data, let refreshToken = String(data: data, encoding: .utf8) {
                                                UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                                                UserDefaults.standard.synchronize()
                                            }
                                        }
                                        task.resume()
                                    }
                                    
                                    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                                    
                                    Auth.auth().signIn(with: credential) { (authResult, error) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                            return
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            viewModel.removeAccount()
                                        }
                                        goToInstructionPage = true
                                    }
                                    
                                default: break
                                }
                            default: break
                            }
                        }
                    )
                    .appleBorder(.black, width: 1, cornerRadius: 25)
                    .signInWithAppleButtonStyle(.white)
                    .clipShape(Capsule())
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 40)
                    .padding(.horizontal, 32)
                    .padding(.top, 35)
                }
                
                Button("Normal Sign-Up") {
                    goToInstructionPage = true
                }
                .buttonStyleBlue() // Assuming this is a custom button style you've defined
                .padding()
            }
            .navigationDestination(isPresented: $goToInstructionPage) {
                DeleteAccountData()
            }
        }
    }
}

struct DeleteAccount_Step1_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccount_Step1().environmentObject(AuthViewModel())
    }
}
