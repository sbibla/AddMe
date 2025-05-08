//
//  MultiplyChallengeApp.swift
//  MultiplyChallenge
//
//  Created by Saar Bibla on 2/15/24.
//

import SwiftUI

@main
struct AdditionChallengeApp: App {
    init() {
        UIView.appearance().isMultipleTouchEnabled = false
            UIView.appearance().isExclusiveTouch = true
    }
    var body: some Scene {
        WindowGroup {
            //            InitScreen( mySoundPtr: InitScreen.Sounds(CorrectAnswer: nil, NextLevel: nil, WrongAnswer: nil))
            InitScreen()
                .task {
                    logManager.shared.userLogLevel = .debug
                    logManager.shared.logMessage("Init logger with level", .info)
                }
        }
    }
}
