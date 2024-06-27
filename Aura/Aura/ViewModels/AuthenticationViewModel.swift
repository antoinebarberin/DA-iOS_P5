//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showingAlert: Bool = false
    @Published var errorMessage: String = ""
    
    let onLoginSucceed: (String) -> ()
    let onLoginFailed: () -> ()
    
    init(onLoginSucceed: @escaping (String) -> (), onLoginFailed: @escaping () -> ()) {
        self.onLoginSucceed = onLoginSucceed
        self.onLoginFailed = onLoginFailed
    }
    
    func login() {
        print("Attempting login with \(username) and \(password)")
        AuthenticationService.getLoginToken(username: username, password: password) { success, token in
            if success, let token = token {
                print("Login succeeded with token: \(token)")
                self.onLoginSucceed(token)
            } else {
                print("Login failed")
                self.errorMessage = "Login failed"
                self.showingAlert = true
                self.onLoginFailed()
            }
        }
    }
}
