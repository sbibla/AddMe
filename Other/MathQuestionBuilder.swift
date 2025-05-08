//
//  MathQuestionBuilder.swift
//  LBTAFireBaseChat
//
//  Created by Saar Bibla on 2/15/24.
//

import Foundation
import SwiftUI

class MathQuestionBuilder: NSObject {
    var resultLocation = (0,0,0)
//    var mathDictionary: [String: (Int, Int, Int, Int)] = [:]
    var resultOne, resultTwo, resultThree, correctAnsLocation: Int
    var equation = ""
    @State private var gameStatusMessage = ""
    
    static let shared = MathQuestionBuilder()
    
    override init() {
        resultOne = 0
        resultTwo = 0
        resultThree = 0
        correctAnsLocation = 0
        logManager.shared.logMessage("Init Game", .debug)
    }
    
    public func generateMultiplicationEquation(_ level: Int)->(String, Int, Int, Int, Int)
    {
        var literalA, literalB : Int
        
        //       If level<10 forcing multiplication 1-100 table
        //    (literalA, literalB) = generateTwoRand(level)
        if level < 10 {
            (literalA,literalB) = (Int.random(in:1 ... 12), Int.random(in:0 ... 12))
        }else {
            (literalA,literalB) = (Int.random(in:1 ... 12), Int.random(in:1 ... 12))
        }
        
        
        return generateMultiplicationRandResults(first: literalA, second: literalB)
    }
    public func generateAdditionEquation(_ level: Int)->(String, Int, Int, Int, Int)
    {
        var literalA, literalB : Int
        
        //       If level<10 forcing multiplication 1-100 table
        //    (literalA, literalB) = generateTwoRand(level)
        if level < 10 {
            (literalA,literalB) = (Int.random(in:1 ... 5), Int.random(in:0 ... 10))
        }else {
            (literalA,literalB) = (Int.random(in:1 ... 12), Int.random(in:1 ... 10))
        }
        
        
        return generateAdditionRandResults(first: literalA, second: literalB)
    }
    
    func generateAdditionRandResults(first: Int, second: Int)->(String,Int,Int,Int,Int)
    {
        //x holds the result, y,z holds fake answer
        //equation holds the equation string
        
        var x,y,z: Int
        let equation: String
        
        equation = "\(first) + \(second)=?"
        x = first + second
        
        //Generate two results that are close to the real answer but not the same
        //If any of the numbers are the same, simply +1 and +3 to the two other results
        //        (y,z) = (Int(arc4random_uniform(UInt32(x+first))),Int(arc4random_uniform(UInt32(x+second))))
        (y,z) = (first+(second+1),(first-1)+second)
        if x==y || x==z || y==z {
            y=x+1
            z=x+3
        }
        
        //rotate location of correct answer
        
        switch Int(arc4random_uniform(3))
        {
        case 0:
            resultLocation.0 += 1
            return (equation,x,y,z,0)
        case 1:
            resultLocation.1 += 1
            return (equation,y,x,z,1)
        case 2:
            resultLocation.2 += 1
            return (equation,z,y,x,2)
        default: logManager.shared.logMessage("error in modulo", .warning)
            return(equation,x,y,z,3)
        }
        
    }
    public func generateSubstructionEquation(_ level: Int)->(String, Int, Int, Int, Int)
    {
        var literalA, literalB : Int
        
        //       If level<10 forcing multiplication 1-100 table
        //    (literalA, literalB) = generateTwoRand(level)
        if level < 10 {
            literalA = Int.random(in:1 ... 12)
            literalB = Int.random(in: 0 ... literalA)
        }else {
            literalA = Int.random(in:1 ... 20)
            literalB = Int.random(in: 0 ... literalA)
        }
        
        
        return generateSubstructionRandResults(first: literalA, second: literalB)
    }
    
    func generateSubstructionRandResults(first: Int, second: Int)->(String,Int,Int,Int,Int)
    {
        //x holds the result, y,z holds fake answer
        //equation holds the equation string
        
        var x,y,z: Int
        let equation: String
        
        equation = "\(first) - \(second)=?"
        x = first - second
        
        //Generate two results that are close to the real answer but not the same
        //If any of the numbers are the same, simply +1 and +3 to the two other results
        //        (y,z) = (Int(arc4random_uniform(UInt32(x+first))),Int(arc4random_uniform(UInt32(x+second))))
        (y,z) = (first-(second+1),(first-1)-second)
        if x==y || x==z || y==z || y < 0 || z < 0 {
            y=x+1
            z=x+2
        }
        
        //rotate location of correct answer
        
        switch Int(arc4random_uniform(3))
        {
        case 0:
            resultLocation.0 += 1
            return (equation,x,y,z,0)
        case 1:
            resultLocation.1 += 1
            return (equation,y,x,z,1)
        case 2:
            resultLocation.2 += 1
            return (equation,z,y,x,2)
        default: logManager.shared.logMessage("error in modulo", .warning)
            return(equation,x,y,z,3)
        }
        
    }
    func generateMultiplicationRandResults(first: Int, second: Int)->(String,Int,Int,Int,Int)
    {
        //x holds the result, y,z holds fake answer
        //equation holds the equation string
        
        var x,y,z: Int
        let equation: String
        
        equation = "\(first) x \(second)=?"
        x = first * second
        
        //Generate two results that are close to the real answer but not the same
        //If any of the numbers are the same, simply +1 and +3 to the two other results
        //        (y,z) = (Int(arc4random_uniform(UInt32(x+first))),Int(arc4random_uniform(UInt32(x+second))))
        (y,z) = (first*(second+1),(first+1)*second)
        if x==y || x==z || y==z {
            y=x+1
            z=x+3
        }
        
        //rotate location of correct answer
        
        switch Int(arc4random_uniform(3))
        {
        case 0:
            resultLocation.0 += 1
            return (equation,x,y,z,0)
        case 1:
            resultLocation.1 += 1
            return (equation,y,x,z,1)
        case 2:
            resultLocation.2 += 1
            return (equation,z,y,x,2)
        default: logManager.shared.logMessage("error in modulo", .warning)
            return(equation,x,y,z,3)
        }
        
    }
    private func pushDictionaryToCloud() {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
//        else {return}
//        let dictionary = "shared.equation"
//        let gameData = ["game": dictionary]
//        FirebaseManager.shared.firestore.collection("games")
//            .document(uid).setData(gameData) { err in
//                if let err = err {
//                    print(err)
//                    self.gameStatusMessage = "\(err)"
//                    return
//                }
//                print("Success")
//            }
    }
    
    
}
