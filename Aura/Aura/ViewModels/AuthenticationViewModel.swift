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
    
    //validation functions :
    
    func isPasswordValid() -> Bool {
        // cf http://regexlib.com pour les conditions
        let passWordTest = NSPredicate(format: "SELF MATCHES %@", "(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,15})$")
        return passWordTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        // cf http://regexlib.com pour les conditions
        let EmailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return EmailTest.evaluate(with: username)
    }
    
    var isSignupComplete: Bool{
        if(!isEmailValid() || !isPasswordValid()){
            return false
        }
        return true
    }
    
    //validation prompt strings :
    
    var emailPrompt: String{
        if isEmailValid(){
            return ""
        }else{
            return "Enter a valid email address"
        }
    }
    
    var passwordPrompt: String{
        if isPasswordValid(){
            return ""
        }else{
            return "Password must be between 6-15 character and contain at least a letter and a number and no special character"
        }
    }
}
