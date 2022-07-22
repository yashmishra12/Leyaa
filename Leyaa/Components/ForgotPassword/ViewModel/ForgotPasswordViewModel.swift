//
//  ForgotPasswordViewModel.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/30/22.
//

import Foundation
import Combine

protocol ForgotPasswordViewModel {
    var service: ForgotPasswordService { get }
    var email: String { get }
    init(service: ForgotPasswordService)
    func sendPasswordResetRequest()
}

final class ForgotPasswordViewModelImpl: ObservableObject, ForgotPasswordViewModel {
    
    let service: ForgotPasswordService
    @Published var email: String = ""
    
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: ForgotPasswordService) {
        self.service = service
    }
    
    func sendPasswordResetRequest() {
        service
            .sendPasswordResetRequest(to: email)
            .sink { res in
                switch res {
                case .failure(let err):
                    print("Failed: \(err)")
                    self.errorMessage = "\(err.localizedDescription)"
                    self.errorOccurred.toggle()
                default: break
                }
            } receiveValue: {
                print("Sending request..")
            }
            .store(in: &subscriptions)
    }
}
