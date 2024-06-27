import Foundation

struct AuthResponse: Decodable {
    let token: String
}

class AuthenticationService: ObservableObject {
    @Published var token: String?
    @Published var errorMessage: String?
    
    private static let url = URL(string: "http://127.0.0.1:8080/auth")!
    
    static func getLoginToken(username: String, password: String, callback: @escaping (Bool, String?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error serializing JSON")
            callback(false, nil)
            return
        }
        
        request.httpBody = httpBody
        
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
                    let responseJSON = try JSONDecoder().decode(AuthResponse.self, from: data)
                    callback(true, responseJSON.token)
                } catch {
                    print("JSON Decoding error: \(error.localizedDescription)")
                    callback(false, nil)
                }
            }
        }
        
        task.resume()
    }
}
