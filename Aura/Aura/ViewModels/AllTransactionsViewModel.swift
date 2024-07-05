//
//  AllTransactionsViewModel.swift
//  Aura
//
//  Created by Antoine Barberin on 05/07/2024.
//

import SwiftUI

class AllTransactionsViewModel: ObservableObject {
    @Published var token: String // Binding token changed to Published var token to manage it inside ViewModel
    @Published var account: Account? // account is optional because it is not available initially
    @Published var totalAmount: String = ""
    @Published var errorMessage: String = ""
    @Published var showingAlert: Bool = false
    @Published var recentTransactions: [Transaction] = []

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
                    self.recentTransactions = account.transactions
                } else {
                    print("Failed to fetch account info")
                    self.errorMessage = "Failed to fetch account info"
                    self.showingAlert = true
                }
            }
        }
    }
}


