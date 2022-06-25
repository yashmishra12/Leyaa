//
//  LeyaaApp.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI
import Firebase

@main
struct LeyaaApp: App {
   @StateObject var viewModel = AuthViewModel()

    init(){
        FirebaseApp.configure()
    }
    
var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(viewModel)
        }
    }
}
