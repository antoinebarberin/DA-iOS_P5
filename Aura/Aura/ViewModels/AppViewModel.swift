//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    var token: String = ""
    
    init() {
        isLogged = false
    }
    
    var authenticationViewModel: AuthenticationViewModel {
           return AuthenticationViewModel(
               onLoginSucceed: { [weak self] token in
                   print("Login succeeded with token: \(token)")
                   self?.token = token
                   self?.isLogged = true
                   
               },
               onLoginFailed: {
                   print("Login failed")
               }
           )
       }
    
    var accountDetailViewModel: AccountDetailViewModel {
        return AccountDetailViewModel(token: token)
    }
}
