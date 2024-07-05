//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUI


class AccountDetailViewModel: ObservableObject {
    @Published var token: String // Binding token changed to Published var token to manage it inside ViewModel
    @Published var account: Account? // account is optional because it is not available initially
    @Published var totalAmount: String = ""
    @Published var errorMessage: String = ""
    @Published var showingAlert: Bool = false
    @Published var recentTransactions: [Transaction] = [
        Transaction(value: 0, label: ""),
        Transaction(value: 0, label: ""),
        Transaction(value: 0, label: "")]

    init(token: String) {
        self.token = token
        fetchAccountInfo()
    }

    private func fetchAccountInfo() {
        AccountDetailService.getAccountInfo(token: token) { success, account in
            DispatchQueue.main.async {
                if success, let account = account {
                    self.account = account
                    self.totalAmount = "\(account.currentBalance)" // Convert Float to String
                    self.recentTransactions[0] = account.transactions[0]
                    self.recentTransactions[1] = account.transactions[1]
                    self.recentTransactions[2] = account.transactions[2]
                } else {
                    print("Failed to fetch account info")
                    self.errorMessage = "Failed to fetch account info"
                    self.showingAlert = true
                }
            }
        }
    }
}


