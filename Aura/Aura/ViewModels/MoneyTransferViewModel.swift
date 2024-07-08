//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: Float = 0.0
    @Published var transferMessage: String = ""
    private let url = URL(string: "http://127.0.0.1:8080/account/transfer")!
    
    func sendMoney() {
        guard !recipient.isEmpty, amount > 0 else {
            transferMessage = "Please enter a valid recipient and amount."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "recipient": recipient,
            "amount": amount
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            transferMessage = "Error serializing JSON"
            return
        }
        
        request.httpBody = httpBody
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.transferMessage = "Error: \(error.localizedDescription)"
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    self.transferMessage = "Invalid response received"
                    return
                }
                if response.statusCode == 200 {
                    self.transferMessage = "Successfully transferred \(self.amount) to \(self.recipient)"
                } else {
                    self.transferMessage = "HTTP Error: \(response.statusCode)"
                }
            }
        }
        
        task.resume()
    }
}
