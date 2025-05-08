//
//  ContentView.swift
//  MultiplyChallenge
//
//  Created by Saar Bibla on 2/15/24.
//

import SwiftUI
import PhotosUI
import AudioToolbox
import AVFoundation


@MainActor
struct InitScreen: View {
    @State private var isMultiPlayer = false
    @State var startGame = false
    @State var withLoginOption = false
    @State var emailAddress = ""
    @State var password = ""
    @State var soundOn = true
    @State var tmpImage = UIImage(named: "Loading.jpg")!
    //Setting to true for MVP until setting screen is ready
    @State var showImagePreview = false
    @State private var showSettings = false
    @State private var showLevelSelection = false
    @State private var selectedLevel = 1
    let gradient = LinearGradient(colors: [.red, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    @StateObject private var PPviewModel = PhotoPickerViewModal()
    @StateObject private var userModel = UserDataViewModel()
    
    var tapGesture: some Gesture {
        TapGesture(count: 3)
            .onEnded {
                showImagePreview.toggle()
            }
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                if(showImagePreview == false){
                    Image("geometryImage")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                VStack(spacing:30) {
                    ImageInCircle(circleImage: tmpImage)
                        .gesture(tapGesture)
                    Text("Solve the tile to Unveil")
                        .font(.system(size: 25))
                        .foregroundColor(.brandPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Text("One Tile at a Time!")
                        .font(.system(size: 25))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        .onTapGesture(count: 3) {
                            userModel.writeUserLevel(level: 1)
                            logManager.shared.logMessage("Reset highest level to 1", .info)
                        }
                    Spacer()
                    
                    //#if DEBUG
                    if(showImagePreview) {
                        LoadedImagesView(selectedImages: PPviewModel.selectedImages)
                    }
                    //#endif
                    
                    //                LoginView()
                    //                    .opacity(withLoginOption ? 1 : 0)
                    Button {
                        PPviewModel.appendDefaultImages(isPokemonMode: true) //Loading pokemon images
                        logManager.shared.logMessage("Starting game for user \(emailAddress)", .debug)
                        showLevelSelection.toggle()
                    } label: {
                        Text("Start Game")
                            .padding()
                            .background {
                                Capsule()
                                    .stroke(gradient, lineWidth: 3.5)
                                    .saturation(1.8)
                            }
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
//                            .bold()
                    }
                    .fullScreenCover(isPresented: $startGame) {
                        GameFile(localBackgroundImage: PPviewModel.selectedImages, 
                               displayStartGameButton: false, 
                               currentLevel: userModel.user.currentLevel, 
                               highScore: userModel.user.highScore)
                            .environmentObject(userModel)
                    }
                    .sheet(isPresented: $showLevelSelection) {
                        LevelSelectionView(selectedLevel: $selectedLevel, isPresented: $showLevelSelection)
                            .environmentObject(userModel)
                            .onDisappear {
                                if selectedLevel > 0 {
                                    logManager.shared.logMessage("User selected level: \(selectedLevel)", .info)
                                    userModel.user.currentLevel = selectedLevel
                                    startGame = true
                                }
                            }
                    }
                    if withLoginOption == true {
                        
                        Button {
                            //Do Something for testing button
                            showSettings.toggle()
                        }label: {
                            Text("🕺🏻New here? \n Create An Account")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                        .fullScreenCover(isPresented: $showSettings, content: {
                            AppSettingsView()
                        })
                    }
                }//.background(Color(UIColor.black)) //VStack
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PhotosPicker(selection: $PPviewModel.imageSelections,maxSelectionCount: 50, matching: .any(of: [.images, .screenshots, .panoramas, .bursts, .livePhotos])) {
                            Image(systemName: "plus")
                            //                            .foregroundColor(Color(.white))
                                .imageScale(.large)
                                .frame(width: 64, height: 64)
                                .modifier(StandardButtonStyle())
                        }                        
                    }
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            AppSettingsView()
//                        } label: {
//                            Image(systemName: "gear")
//                                .modifier(StandardButtonStyle())
//                        }
//                    }
                    
                }
            }
        }
        .environmentObject(UserDataViewModel())
    }
}

#Preview {
    InitScreen()
    //    InitScreen( mySoundPtr: InitScreen.Sounds(CorrectAnswer: nil, NextLevel: nil, WrongAnswer: nil))
}

struct SettingsGear: View {
    var body: some View {
        Spacer()
    }
}

