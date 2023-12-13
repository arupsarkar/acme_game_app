//
//  GameModel.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/10/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import SwiftUI

class GameModel: ObservableObject {
    @Published var targetColor = Color.random
//    @Published var guessColor = Color.white
 
    
    @Published var redValue = 0.5
    @Published var greenValue = 0.5
    @Published var blueValue = 0.5
    
    var guessColor: Color {
        Color(red: redValue, green: greenValue, blue: blueValue)
    }
    
    var score: String {
        let scoreValue = calculateScore() // Assume this is your method to calculate the numeric score

        switch scoreValue {
            case 0..<10:
                return "Just starting out" + " (" + String(scoreValue) + ")"
            case 10..<20:
                return "Getting warmer" + " (" + String(scoreValue) + ")"
            case 20..<30:
                return "Not bad!" + " (" + String(scoreValue) + ")"
            case 30..<40:
                return "Looking good!" + " (" + String(scoreValue) + ")"
            case 40..<50:
                return "Great job!" + " (" + String(scoreValue) + ")"
            case 50..<60:
                return "Impressive!" + " (" + String(scoreValue) + ")"
            case 60..<70:
                return "Very impressive!" + " (" + String(scoreValue) + ")"
            case 70..<80:
                return "Superb!" + " (" + String(scoreValue) + ")"
            case 80..<95:
                return "Almost perfect!" + " (" + String(scoreValue) + ")"
            case 95...100:
                return "Nailed it!" + " (" + String(scoreValue) + ")"
            default:
                return "Out of bounds" + " (" + String(scoreValue) + ")"
        }
    }
    
    private func calculateScore() -> Int {
        // Calculate the score based on how close guessColor is to targetColor
        let targetRGB = targetColor.rgb
        let guessRGB = Color(red: redValue, green: greenValue, blue: blueValue).rgb

        let redDiff = abs(targetRGB.red - guessRGB.red)
        let greenDiff = abs(targetRGB.green - guessRGB.green)
        let blueDiff = abs(targetRGB.blue - guessRGB.blue)

        let totalDiff = (redDiff + greenDiff + blueDiff) / 3 // Average difference

        // Convert this difference into a score, for example:
        return Int((1 - totalDiff) * 100) // Closer to 100 for closer match
    }
    
//    func checkGuess() {
//        // Update guessColor based on the slider values
//        guessColor = Color(red: redValue, green: greenValue, blue: blueValue)
//    }

    func newRound() {
        // Generate a new targetColor
        targetColor = Color.random
        
        // Reset slider values
        redValue = 0.5
        greenValue = 0.5
        blueValue = 0.5
    }
    
}

extension Color {
    static var random: Color {
        Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
    
    var rgb: (red: Double, green: Double, blue: Double) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return (Double(red), Double(green), Double(blue))
    }
}
