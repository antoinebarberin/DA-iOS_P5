//
//  AccountDetailService.swift
//  Aura
//
//  Created by Antoine Barberin on 03/07/2024.
//

import Foundation
import SwiftUI

struct Account: Decodable {
    let currentBalance: Float
    let transactions: [Transaction]

    
    enum CodingKeys: CodingKey {
        case currentBalance
        case transactions
    }
    
    init(currentBalance: Float, transactions: [Transaction]){
        self.currentBalance = currentBalance
        self.transactions = transactions
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentBalance = try container.decode(Float.self, forKey: .currentBalance)
        self.transactions = try container.decode([Transaction].self, forKey: .transactions)
    }
}

struct Transaction: Decodable, Identifiable{
    let value: Float
    let label: String
    let id: UUID = UUID()
    
    enum CodingKeys: CodingKey {
        case value
        case label
        case id
    }
    init(value: Float, label: String){
        self.value = value
        self.label = label
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Float.self, forKey: .value)
        self.label = try container.decode(String.self, forKey: .label)
    }
}
class AccountDetailService: ObservableObject {

    @Published var errorMessage: String?
    @State private var account = Account(currentBalance: 0, transactions: [])
    
    private static let url = URL(string: "http://127.0.0.1:8080/account")!
    
    static func getAccountInfo(token: String,callback: @escaping (Bool, Account?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "token")
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    callback(false, nil)
                    return
                }
                guard let data = data else {
                    print("No data received")
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid response received")
                    callback(false, nil)
                    return
                }
                if response.statusCode != 200 {
                    print("HTTP Error: \(response.statusCode)")
                    callback(false, nil)
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(Account.self, from: data)
                    callback(true, responseJSON)
                } catch {
                    print("JSON Decoding error: \(error.localizedDescription)")
                    callback(false, nil)
                }
            }
        }
        
        task.resume()
    }
}
