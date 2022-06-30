//
//  ErrorMessage.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/30/22.
//

import Foundation

class A: ObservableObject {

    @Published var showAlert = false

    func buttonTapped() {
        //handle request and then set to true to show the alert
        self.showAlert = true
    }

}
