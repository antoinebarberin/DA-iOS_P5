//
//  AllTransactionsView.swift
//  Aura
//
//  Created by Antoine Barberin on 05/07/2024.
//

import SwiftUI

struct AllTransactionsView: View {
    @ObservedObject var viewModel: AllTransactionsViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView{
            LazyVStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text("Your Balance")
                        .font(.headline)
                    Text(viewModel.totalAmount)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(hex: "#94A684"))
                    Image(systemName: "eurosign.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(Color(hex: "#94A684"))
                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Transactions")
                        .font(.headline)
                        .padding([.horizontal])
                    ForEach(viewModel.recentTransactions) { transaction in
                        HStack {
                            Image(systemName: transaction.value > 0.0 ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                                .foregroundColor(transaction.value > 0.0 ? .green : .red)
                            Text(transaction.label)
                            Spacer()
                            Text("\(transaction.value)")
                                .fontWeight(.bold)
                                .foregroundColor(transaction.value > 0.0 ? .green : .red)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding([.horizontal])
                    }
                }
                
            }
            
            .onTapGesture {
                self.endEditing(true)
            }
        }
    }
        
}

#Preview {
    AccountDetailView(viewModel: AccountDetailViewModel(token: ""), viewModelAll: AllTransactionsViewModel(token: ""))
}

