//
//  LoginView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/21/24.
//

import SwiftUI

@MainActor
struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var userData: UserDataViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Image("FrankZappa")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.pink, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.bottom, 30)
                
                Form {
                    TextField("Email Address", text: $viewModel.emailAddress)
                        .disableAutocorrection(true)
                        .textCase(.lowercase)
                    SecureField("Password", text: $viewModel.password)
                        .disableAutocorrection(true)
                    Button {
                        //Attempt login
                        viewModel.login()
                    } label: {
                        Text("Log In")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(width: 260, height: 50)
                            .foregroundColor(.white)
                            .background(.pink)
                            .cornerRadius(10)
                    }
                }/*.disabled(viewModel.emailAddress.isEmpty || viewModel.password.isEmpty)*/
            }
        }.alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, 
                 message: alertItem.message, 
                 dismissButton: alertItem.dismissButton)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserDataViewModel())
}


