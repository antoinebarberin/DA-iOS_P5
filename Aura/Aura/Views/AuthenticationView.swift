//
//  AuthenticationView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    let gradientStart = Color(hex: "#94A684").opacity(0.7)
    let gradientEnd = Color(hex: "#94A684").opacity(0.0) // Fades to transparent

    @ObservedObject var viewModel: AuthenticationViewModel

    
    var body: some View {
        
        ZStack {
                    // Background gradient
                    LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]), startPoint: .top, endPoint: .bottomLeading)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            
                        Text("Welcome !")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        EntryFields(placeHolder: "Adresse email", field: $viewModel.username, isSecure: false, prompt: viewModel.emailPrompt)

                        EntryFields(placeHolder: "Mot de passe", field: $viewModel.password, isSecure: true, prompt: viewModel.passwordPrompt)
                        
                        Button(action: {
                            // Handle authentication logic here
                            viewModel.login()
                        }) {
                            Text("Se connecter")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black) // You can also change this to your pastel green color
                                .cornerRadius(8)
                            
                        }
                        .opacity(viewModel.isSignupComplete ? 1 : 0.6)
                        .disabled(!viewModel.isSignupComplete)
                    }
                    .padding(.horizontal, 40)
                }
        .onTapGesture {
            self.endEditing(true)  // This will dismiss the keyboard when tapping outside
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Login Failed"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
}


struct EntryFields: View {
    var placeHolder: String
    @Binding var field: String
    var isSecure: Bool = false
    var prompt: String
    
    var body: some View {
        VStack{
            if isSecure{
                SecureField(placeHolder, text: $field).textInputAutocapitalization(.none)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
            }else{
                TextField(placeHolder, text: $field).textInputAutocapitalization(.none)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
            }
            Text(prompt)
        }
    }
}

#if DEBUG
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel(onLoginSucceed: { _ in }, onLoginFailed: { }))
    }
}
#endif
