//
//  AppSettings.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 5/3/24.
//

import SwiftUI

struct AppSettingsView: View {
    
    @State private var userEmail            = ""
    @State private var userPass             = ""
    @State private var muteAllSounds        = false
    @State private var minimalSounds        = false
    @State private var allowRemoteImages    = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Text("X")
                        .tint(.red)
                }
                Form {
                    Section(header: Text("Login Details")) {
                        TextField("Email", text: $userEmail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        SecureField("Password", text: $userPass)
                        Button {
                            print("login user")
                        }label: {
                            Text("Login")
                                .tint(.orange)
                        }
                    }
                    Section(header: Text("Sounds")) {
                        Toggle("Mute all sounds", isOn: $muteAllSounds)
                        Toggle("Minimize sounds", isOn: $minimalSounds)
                            .disabled(muteAllSounds)
                    }.toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                    
                    Section(header: Text("Images")) {
                        Button {
                            
                        }label: {
                            Text("Change Background Pictures")
                        }
                        Toggle("Allow remote Images", isOn: $allowRemoteImages)
                    }.toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                }
                Spacer()
            }
        }
    }
}

struct MiniSettings: View {
    @State  var muteAllSounds        = false
    //            @State private var minimalSounds        = false
    //            @State private var allowRemoteImages    = true
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Text("X")
                        .tint(.red)
                }
                Form {
                    Section(header: Text("Sounds")) {
                        Toggle("Mute all sounds", isOn: $muteAllSounds)
                        //                                Toggle("Minimize sounds", isOn: $minimalSounds)
                        //                                    .disabled(muteAllSounds)
                    }.toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                    
//                    Section(header: Text("Images")) {
//                        Button {
//                            
//                        }label: {
//                            Text("Change Background Pictures")
//                        }
//                        //                                Toggle("Allow remote Images", isOn: $allowRemoteImages)
//                    }.toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                }
                Spacer()
            }
        }
    }
}


#Preview {
//    AppSettingsView()
    MiniSettings()
}
