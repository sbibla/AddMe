//
//  GamificationView.swift
//  LBTAFireBaseChat
//
//  Created by Saar Bibla on 2/15/24.
//

import SwiftUI
//import Firebase
//import FirebaseStorage
import AudioToolbox
import AVFoundation





struct GameFile: View {
    @State var localBackgroundImage: [UIImage]
    @State var audioPlayer: AVAudioPlayer!
    @State var soundsMuted = false
    @State var displayStartGameButton: Bool
    @State var currentLevel: Int
    @State var highScore: Int
    
    init(localBackgroundImage: [UIImage], displayStartGameButton: Bool, currentLevel: Int, highScore: Int) {
        self._localBackgroundImage = State(initialValue: localBackgroundImage)
        self._displayStartGameButton = State(initialValue: displayStartGameButton)
        self._currentLevel = State(initialValue: currentLevel)
        self._highScore = State(initialValue: highScore)
        logManager.shared.logMessage("GameFile initialized with level: \(currentLevel)", .info)
    }
    
    @State private var showImage = [false, false, false, false,
                                    false, false, false, false,
                                    false, false, false, false,
                                    false, false, false, false]
    @State private var disableButton = [false, false, false, false,
                                        false, false, false, false,
                                        false, false, false, false,
                                        false, false, false, false]
    
    @Environment(\.dismiss) var dismiss
    @State var initmathDictionary = ["1+1=?", "1+2=?","1+3=?", "1+4=?",
                                     "2+1=?", "2+2=?", "2+3=?", "2+4=?",
                                     "3+1=?", "3+2=?", "3+3=?", "3+4=?",
                                     "4+1=?", "4+2=?", "4+3=?", "4+4=?"]
    
    //    @State var initmathDictionary: [String] = []
    
    @State private var pmathDictionary: [String: (Int, Int, Int, Int)] = [:]
    @State var currentEquation = "Level 1"
    @State var currentEquationAnswers = ["Ans1", "Ans2", "Ans3"]
    @State var currentButton = 0
    @State var levelComplete = false
    @State var soundsInitialized = false
    @State private var dbStatusMessage = ""
    @State var mistakesInLevel = 0
    @State private var puzzlePickedImage: UIImage?
    @State var gameBackgroundImagesDictionary: [Int: UIImage] = [:]
    @State var shouldShowImagePicker = false
    @State var bonusVideoID = "K4TOrB7at0Y"
    @State var disableAnswerButtonsUntilNextQuestion = false
    @State private var hasTimeElapsed = false
    @State private var testMode = false
    @State var advanceToNextLevel = false
    @State private var allTilesDisabled = false
    @State private var isBonusScreen = false
    @State private var isBonusVideoOn = false
//    @State var startBonusLevel = false
    @State var randOkSound: URL? = nil
    @State var randWrongSound: URL? = nil
    @State var CorrectAnswer1: URL? = nil
    @State var CorrectAnswer2: URL? = nil
    @State var CorrectAnswer3: URL? = nil
    @State var CorrectAnswer4: URL? = nil
    @State var CorrectAnswer5: URL? = nil
    @State var CorrectAnswer6: URL? = nil
    @State var CorrectAnswer7: URL? = nil
    @State var CorrectAnswer8: URL? = nil
    @State var CorrectAnswer9: URL? = nil
    
    @State var NextLevel: URL? = nil
    @State var RepeatLevel: URL? = nil
    @State var Bonus: URL? = nil
    @State var WrongAnswer: URL? = nil
    @State var WrongAnswer2: URL? = nil
    @State var WrongAnswer3: URL? = nil
    @State var WrongAnswer4: URL? = nil
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData: UserDataViewModel
    
    
    
    let encouragementTextArray = ["🙏🏼 Believe 👋🏼","Good Job 💪🏼","Bravo 👋🏼", "Excellent 🌈", "Perfecto ⚡️", "Respect!! 😎", "Nice 💯", "Good On'ya 💪🏼", "That is right! 🍭", "Bullseye 🎯", "Ready for more ❔", "Correct Answer 👍🏽", "🎉 Amazing 🎉", "Keep Pushing 🫸🏼", "👩‍👦‍👦🤞👨", "🧑👈🙏💪", "😔👈🏋🥇", "Very good🕺🏻"]
    //    @EnvironmentObject var userData: UserData
    let pokemonVideoArray = ["SuV3bEYQWeg","E-A_pn1_pCw","AG4GSlMhGHs", "xM24hiwTAe8", "EKwbZQXNWsk"]
    
    var body: some View {
        ZStack {
            BackgroundPuzzleImage
            VStack{
                Text("Level \(currentLevel)")
                    .bold()
                Spacer()
            }
            VStack(spacing: 1) {
                QuestionButtons
                Spacer()
                    .frame(minWidth: 100, maxWidth: .infinity)
                    .background(.black)
                    .opacity(0.9)
            }
            .overlay(
                showAnswerButtons, alignment: .bottom)
            .navigationBarHidden(true)
//            .overlay(displayStartGameButton ? startGameButton : nil, alignment: .center )
            .fullScreenCover(isPresented: $isBonusScreen, content: {
                BonusView(isPresented: $isBonusScreen, highScore: $highScore)
            })
            .fullScreenCover(isPresented: $isBonusVideoOn, content: {
                YoutubePlayerView(isPresented: $isBonusVideoOn, bonVideoId: bonusVideoID)
            })
            
        }
        .onAppear{
            logManager.shared.logMessage("GameFile appeared with level: \(currentLevel)", .info)
            startGame()
        }
    }
    
    var QuestionButtons: some View {
        ForEach(0..<4) {row in
            HStack(spacing: 1) {
                //                    Spacer()
                ForEach(0..<4) { col in
                    Button {
                        currentButton = col+4*row
                        //                                userData.username = "saar"
                        currentEquation = (levelComplete ? "Advancing to level \(currentLevel)" : initmathDictionary[currentButton])
                        populateAnswers()
                    } label: {
                        Text(self.showImage[col+4*row] ? "" : initmathDictionary[col+4*row])
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                            .background(self.showImage[col+4*row] ? Color.clear : .indigo)
                            .tag("\(col+4*row)")
                    }
                    .disabled(disableButton[col+4*row] || allTilesDisabled)
                }
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 0.5)
            }.ignoresSafeArea()
        }
    }
    var BackgroundPuzzleImage: some View {
        Image(uiImage: localBackgroundImage.count <= (currentLevel-1) ? UIImage(named: "Loading.jpg")! : localBackgroundImage[currentLevel-1])
            .resizable()
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .aspectRatio(contentMode: .fit)
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .blur(radius: disableButton.allSatisfy({$0}) ? 0 : 15)
    }
    
    //    private func initDictionary()    {
    //        for num in (0..<16) {
    //            pmathDictionary[initmathDictionary[num]] = (-1,-1,-1,-1)
    //        }
    //    }
    //
    func initSounds(){
        logManager.shared.logMessage("Initializing sounds", .debug)
        CorrectAnswer1 = Bundle.main.url(forResource: "CorrectAnswer-1.wav", withExtension: nil)
        if CorrectAnswer1 == nil { fatalError("Unable to find CorrrectAnswer.wav in bundle") }
        
        CorrectAnswer2 = Bundle.main.url(forResource: "CorrectAnswer-2.wav", withExtension: nil)
        if CorrectAnswer2 == nil { fatalError("Unable to find CorrrectAnswer2.wav in bundle") }
        
        CorrectAnswer3 = Bundle.main.url(forResource: "CorrectAnswer-3.wav", withExtension: nil)
        if CorrectAnswer3 == nil { fatalError("Unable to find CorrrectAnswer3.wav in bundle") }
        
        CorrectAnswer4 = Bundle.main.url(forResource: "CorrectAnswer-4.wav", withExtension: nil)
        if CorrectAnswer4 == nil { fatalError("Unable to find CorrrectAnswer4.wav in bundle") }
        
        CorrectAnswer5 = Bundle.main.url(forResource: "CorrectAnswer-5.wav", withExtension: nil)
        if CorrectAnswer5 == nil { fatalError("Unable to find CorrrectAnswer5.wav in bundle") }
        
        CorrectAnswer6 = Bundle.main.url(forResource: "CorrectAnswer-6.wav", withExtension: nil)
        if CorrectAnswer6 == nil { fatalError("Unable to find CorrrectAnswer6.wav in bundle") }
        
        CorrectAnswer7 = Bundle.main.url(forResource: "CorrectAnswer-7.wav", withExtension: nil)
        if CorrectAnswer7 == nil { fatalError("Unable to find CorrrectAnswer7.wav in bundle") }
        
        CorrectAnswer8 = Bundle.main.url(forResource: "CorrectAnswer-8.wav", withExtension: nil)
        if CorrectAnswer8 == nil { fatalError("Unable to find CorrrectAnswer8.wav in bundle") }
        
        CorrectAnswer9 = Bundle.main.url(forResource: "CorrectAnswer-9.wav", withExtension: nil)
        if CorrectAnswer9 == nil { fatalError("Unable to find CorrrectAnswer9.wav in bundle") }
        
        NextLevel = Bundle.main.url(forResource: "NextLevel.aiff", withExtension: nil)
        if NextLevel == nil {    fatalError("Unable to find NextLevel.aiff in bundle") }
        
        RepeatLevel = Bundle.main.url(forResource: "RepeatLevel.aiff", withExtension: nil)
        if RepeatLevel == nil { fatalError("Unable to find RepeatLevel.aiff in bundle") }
        
        Bonus = Bundle.main.url(forResource: "Bonus.wav", withExtension: nil)
        if Bonus == nil { fatalError("Unable to find Bonus.wav in bundle") }
        
        WrongAnswer = Bundle.main.url(forResource: "WrongAnswer.aiff", withExtension: nil)
        if WrongAnswer == nil { fatalError("Unable to find WrongAnswer.aiff in bundle") }
        
        WrongAnswer2 = Bundle.main.url(forResource: "WrongAnswer-2.wav", withExtension: nil)
        if WrongAnswer2 == nil { fatalError("Unable to find WrongAnswer2 in bundle") }
        
        WrongAnswer3 = Bundle.main.url(forResource: "WrongAnswer-3.wav", withExtension: nil)
        if WrongAnswer3 == nil { fatalError("Unable to find WrongAnswer3 in bundle") }
        
        WrongAnswer4 = Bundle.main.url(forResource: "WrongAnswer-4.wav", withExtension: nil)
        if WrongAnswer4 == nil { fatalError("Unable to find WrongAnswer4 in bundle") }
        
        
        
    }
    
    func playSounds(_ soundURL: URL){
        if soundsMuted == true {
            return
        }else {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                logManager.shared.logMessage(error.localizedDescription, .warning)
            }
            audioPlayer.play()
        }
    }
    
    func playSounds(_ soundFileName : String) {
        if soundsMuted == true {             // Have a toggle to mute sound in app
            guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
                fatalError("Unable to find \(soundFileName) in bundle")
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                logManager.shared.logMessage(error.localizedDescription, .warning)
            }
            audioPlayer.play()
        }
    }
    
    private func buildLevel(level: Int) {
        var resultOne, resultTwo, resultThree, resultLocation: Int
        var equation = ""
        mistakesInLevel = 0
        pmathDictionary.removeAll()
        logManager.shared.logMessage("Starting new game, pmathSize:\(pmathDictionary.count)", .debug)
        
        //        building dictionary until reaches 16 questions. Looping to remove duplicate keys
        while pmathDictionary.count < 12 {
//            (equation, resultOne, resultTwo, resultThree, resultLocation) = MathQuestionBuilder.shared.generateMultiplicationEquation(10)
            (equation, resultOne, resultTwo, resultThree, resultLocation) = MathQuestionBuilder.shared.generateAdditionEquation(level)

            logManager.shared.logMessage("Inserting to pmath:\(equation), \(resultOne), \(resultTwo), \(resultThree), \(resultLocation)", .debug)
            
            if (pmathDictionary.updateValue((resultOne, resultTwo, resultThree, resultLocation), forKey: equation) != nil) {
                logManager.shared.logMessage("value \(equation) already exists", .debug)
            }
        }
        
        while pmathDictionary.count < 16 {
//            (equation, resultOne, resultTwo, resultThree, resultLocation) = MathQuestionBuilder.shared.generateMultiplicationEquation(10)
            (equation, resultOne, resultTwo, resultThree, resultLocation) = MathQuestionBuilder.shared.generateSubstructionEquation(level)
            

            logManager.shared.logMessage("Inserting to pmath:\(equation), \(resultOne), \(resultTwo), \(resultThree), \(resultLocation)", .debug)
            
            if (pmathDictionary.updateValue((resultOne, resultTwo, resultThree, resultLocation), forKey: equation) != nil) {
                logManager.shared.logMessage("value \(equation) already exists", .debug)
            }
        }
        
        
        logManager.shared.logMessage("Dictionary built with size \(pmathDictionary.count)", .debug )
        initLevelButtons()
        advanceToNextLevel = false
    }
    private func initLevelButtons() {
        for count in 0...15 {
            disableButton[count] = false
            showImage[count] = false
        }
    }
    private func startGame(){
        displayStartGameButton = false
        levelComplete = false
        currentEquation = "Level \(currentLevel)"
        buildLevel(level: currentLevel)
        populateQuestions()
        if soundsInitialized == false {
            initSounds()
            soundsInitialized = true
        }
        
        
        for eq in pmathDictionary {
            logManager.shared.logMessage("Equation \(eq.key) answers: \(eq.value) correct: \(eq.value.3)", .debug)
        }
        logManager.shared.logMessage("Starting game with \(pmathDictionary.count) questions in each level \n Current level \(currentLevel)", .info)
    }
    
    private func populateQuestions(){
        var keyNumber = 0
        
        initmathDictionary.removeAll()
        
        
        for eq in pmathDictionary {
            if keyNumber > 15 {
                perror("Too many elements in dictionary \(pmathDictionary.count)")
                return}
            
            //            initmathDictionary[keyNumber] = eq.key
            initmathDictionary.append(eq.key)
            keyNumber+=1
            //            #warning("Hardcoded keyNumber will cause index out of range")
        }
    }
    func populateAnswers(){
        currentEquationAnswers[0] = String(pmathDictionary[currentEquation]?.0 ?? -1)
        currentEquationAnswers[1] = String(pmathDictionary[currentEquation]?.1 ?? -1)
        currentEquationAnswers[2] = String(pmathDictionary[currentEquation]?.2 ?? -1)
        disableAnswerButtonsUntilNextQuestion = false
    }
    private var startGameButton: some View {
        HStack(spacing: 16) {
            VStack {
                Button {
                    startGame()
                }label: {
                    Text("Start game 🕺🏻")
                        .font(.system(size: 122, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .background(.black)
                    
                }
            }
        }
    }
    
    private var showAnswerButtons: some View {
        VStack {
            Button {
            } label: {
                HStack {
                    Spacer()
                    Text(disableAnswerButtonsUntilNextQuestion ? encouragementTextArray[Int.random(in:0 ... encouragementTextArray.count-1)] : currentEquation)
                        .font(.system(size: 26, weight: .bold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(Color.orange)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
                
            }
            .simultaneousGesture(TapGesture(count: 3).onEnded {
                //                if(testMode) {
                //                    currentLevel += 1
                //
                //                    logManager.shared.logMessage("NextLevel pressed", .debug)
                //                }else {
                //                    presentationMode.wrappedValue.dismiss()
                //                }
                currentLevel += 1
            })
            
            .buttonStyle(MyButtonStyle(color: .black))
            //            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                Button {
                    checkAnswer(userAnswered: 0)
                } label: {
                    HStack {
                        Spacer()
                        Text(disableAnswerButtonsUntilNextQuestion ? "👍🏼" : self.currentEquationAnswers[0])
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .background(Color.gray)
                    .cornerRadius(32)
                    
                    .padding(.horizontal)
                    .shadow(radius: 15)
                }.disabled(disableAnswerButtonsUntilNextQuestion)
                Button {
                    checkAnswer(userAnswered: 1)
                } label: {
                    HStack {
                        Spacer()
                        Text(disableAnswerButtonsUntilNextQuestion ? "👍🏼" : currentEquationAnswers[1])
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .background(Color.gray)
                    .cornerRadius(32)
                    
                    .padding(.horizontal)
                    .shadow(radius: 15)
                }.disabled(disableAnswerButtonsUntilNextQuestion)
                Button {
                    checkAnswer(userAnswered: 2)
                } label: {
                    HStack {
                        Spacer()
                        Text(disableAnswerButtonsUntilNextQuestion ? "👍🏼" : currentEquationAnswers[2])
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .background(Color.gray)
                    .cornerRadius(32)
                    
                    .padding(.horizontal)
                    .shadow(radius: 15)
                }.disabled(disableAnswerButtonsUntilNextQuestion)
            }
        }
    }
    private func checkAnswer(userAnswered: Int){
        if testMode == true {
            correctAnswer()
            return
        }
        if userAnswered == pmathDictionary[currentEquation]?.3 {
            correctAnswer()
        } else {
            wrongAnswer()
        }
    }
    private func wrongAnswer() {
        mistakesInLevel += 1
        randomizeWrongSound()
        playSounds(randWrongSound!)
        
    }
    
    private func randomizeOkSound() {
        switch Int.random(in:1 ... 9){
        case 1: randOkSound = CorrectAnswer1
        case 2: randOkSound = CorrectAnswer2
        case 3: randOkSound = CorrectAnswer3
        case 4: randOkSound = CorrectAnswer4
        case 5: randOkSound = CorrectAnswer6
        case 6: randOkSound = CorrectAnswer7
        case 7: randOkSound = CorrectAnswer8
        case 8: randOkSound = CorrectAnswer9
        case 9: randOkSound = CorrectAnswer9
        default:
            randOkSound = CorrectAnswer1
        }
    }
    
    private func randomizeWrongSound() {
        switch Int.random(in:1 ... 4){
        case 1: randWrongSound = WrongAnswer
        case 2: randWrongSound = WrongAnswer2
        case 3: randWrongSound = WrongAnswer3
        case 4: randWrongSound = WrongAnswer4
        default:
            randWrongSound = WrongAnswer
        }
    }
    
    private func correctAnswer() {
        randomizeOkSound()
        playSounds(randOkSound!)
        showImage[currentButton].toggle()
        disableButton[currentButton].toggle()
        disableAnswerButtonsUntilNextQuestion.toggle()
        
        //All answers are correct
        if disableButton.allSatisfy({$0}) {
            levelComplete = true
            logManager.shared.logMessage("Level completed with \(mistakesInLevel) mistakes",.debug)
            disableAnswerButtonsUntilNextQuestion = false
            if mistakesInLevel < 6 {
                advanceToNextLevel = true
                //check if Bonus level
                if (currentLevel % 5 == 0) {
                    playSounds(Bonus!)
                    DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
                        isBonusVideoOn.toggle()
                    })
                } else {
                    currentEquation = "Setting Level \(currentLevel+1)"
                    //save current level
                    userData.writeUserLevel(level: currentLevel)
                    playSounds(NextLevel!)
                }
            } else {
                advanceToNextLevel = false
                logManager.shared.logMessage("Too many mistakes (\(mistakesInLevel)), repeat level", .debug)
                currentEquation = "Repeat Level \(currentLevel)"
                playSounds(RepeatLevel!)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
                if advanceToNextLevel == true {
                    switch currentLevel {
                    case 5: bonusVideoID = pokemonVideoArray[0]
                    case 10: bonusVideoID = pokemonVideoArray[1]
                    case 15: bonusVideoID = pokemonVideoArray[2]
                    case 20: bonusVideoID = pokemonVideoArray[3]
                    case 25: bonusVideoID = pokemonVideoArray[3]
                    default: bonusVideoID = "3RBnvv_82R0" //Sunset
                    }
                    currentLevel += 1
                    userData.writeUserLevel(level: currentLevel)
                }
                currentEquation = "Choose an equation"
                startGame()
            })
        }
    }
    private func announceLevelWinner() {
        
    }
    
    private func loadUserImagesFromStorage() {
        
    }
    
    private func writeLevelFinishTime(){
        //        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        //        else {return}
        //        let date = Date()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        //        let dateString = formatter.string(from: date)
        //        print(dateString)
        //
        //
        //        let userData = ["uid": uid, "LevelFinishTime" : dateString]
        //
        //        FirebaseManager.shared.firestore.collection("Arena")
        //            .document(/*uid*/"game1").updateData(userData) { err in
        //                if let err = err {
        //                    print(err)
        //                    self.dbStatusMessage = "\(err)"
        //                    return
        //                }
        //                print("Success")
        //
        //
        //            }
    }
}

#Preview {
    GameFile(localBackgroundImage: [UIImage(named: "DefaultImage10.jpg")!, UIImage(named: "Loading.jpg")!], displayStartGameButton: true, currentLevel: 1, highScore: 0)
}
