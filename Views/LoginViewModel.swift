//
//  LoginViewModel.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 5/1/24.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var alertItem: AlertItem?
    
    var isValidForm: Bool {
        guard !emailAddress.isEmpty && !password.isEmpty else {
            alertItem = AlertContext.InvalidForm
            print("Invalid Form")
            return false
        }
        guard emailAddress.isValidEmail else {
            alertItem = AlertContext.InvalidEmail
            print("Invalid Email")
            return false
        }
        
        return true
    }
    
    func login() {
        guard isValidForm else {return}
        print("Changes have been saved successfully")
    }
    
}
