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
    
    //validation functions :
    
    func isAmountValid() -> Bool {
        // cf http://regexlib.com pour les conditions
        return amount > 0
    }
    
    func isRecipientValid() -> Bool {
        // cf http://regexlib.com pour les conditions
        let EmailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        let PhoneNumberTest = NSPredicate(format: "SELF MATCHES %@", "^(0|\\+33)[1-9]([-. ]?[0-9]{2}){4}$")
        return EmailTest.evaluate(with: recipient) || PhoneNumberTest.evaluate(with: recipient)
    }
    
    var isSignupComplete: Bool{
        if(!isAmountValid() || !isRecipientValid()){
            return false
        }
        return true
    }
    
    //validation prompt strings :
    
    var AmountPrompt: String{
        if isAmountValid(){
            return ""
        }else{
            return "Amount must be a positive number"
        }
    }
    
    var RecipientPrompt: String{
        if isRecipientValid(){
            return ""
        }else{
            return "Please enter a valid email address or a french phone number"
        }
    }
}
