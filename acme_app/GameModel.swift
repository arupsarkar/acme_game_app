//
//  GameModel.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/10/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import SwiftUI
import SalesforceSDKCore
//struct Event: Codable {
//    var deviceId: String
//    var lastModifiedDate: String
//    enum CodingKeys: String, CodingKey {
//        case deviceId = "deviceId"
//        case lastModifiedDate = "Last_Modified_Date"
//    }
//}
//
//struct EventContainer: Codable {
//    let dataValue: [Event]
//}

struct EventData: Codable {
    var deviceId: String
    var lastModifiedDate: String
    var eventDateTime: String
    var dataSourceObject: String
    var dataSource: String
    var category: String
    var eventId: String
    var eventType: String
    var sessionId: String
    var internalOrg: String
    var score: Int
    var userId: String
    var statusCode: String

    enum CodingKeys: String, CodingKey {
        case deviceId = "deviceId"
        case lastModifiedDate = "Last_Modified_Date"
        case eventDateTime = "eventDateTime"
        case dataSourceObject = "Data_Source_Object"
        case dataSource = "Data_Source"
        case category = "category"
        case eventId = "eventId"
        case eventType = "eventType"
        case sessionId = "sessionId"
        case internalOrg = "Internal_Org"
        case score = "score"
        case userId = "userId"
        case statusCode = "status_code"
    }
}

struct EventDataContainer: Codable {
    let data: [EventData]
}




class GameModel: ObservableObject {
    
    
    @Published var targetColor = Color.random
//    @Published var guessColor = Color.white
 
    
    @Published var redValue = 0.5
    @Published var greenValue = 0.5
    @Published var blueValue = 0.5
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRequestInProgress = false
    @Published var buttonText = "New Round"
    
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
        
        DispatchQueue.main.async {
            self.isRequestInProgress = true
            self.buttonText = "Request in progress.."
        }
//        self.isRequestInProgress = true
        // Generate a new targetColor
        targetColor = Color.random
        
        // Reset slider values
        redValue = 0.5
        greenValue = 0.5
        blueValue = 0.5
        // call the data cloud ingestion API to post the data
        let currentDate = Date()
        let formattedDate = currentDate.toISO8601Format()
        let event = EventData(
        deviceId: "B47FD0FF-C022-429F-A59F-7414DF3E3C28",
        lastModifiedDate: formattedDate,
        eventDateTime: formattedDate,
        dataSourceObject: "game_event_api-1ds8a000000fxptAAA",
        dataSource: "1ds8a000000fxptAAA",
        category: "Color Matcher",
        eventId: UUID().uuidString,
        eventType: "Color Matcher Score Submitted",
        sessionId: UUID().uuidString,
        internalOrg: UserAccountManager.shared.currentUserAccountIdentity!.orgId,
        score: calculateScore(),
        userId: "2c1b2a8da0a7c6232f758c8a79eb3060",
        statusCode: "Active"
        )
        
//        let simpleEventData = Event(deviceId: "SimpleTestID",lastModifiedDate: "2023-12-17T12:15:00.000Z")
//
//        
//        let eventContainer = EventContainer(dataValue: [simpleEventData])
        let eventDataContainer = EventDataContainer(data: [event])
        do {
            let jsonData = try JSONEncoder().encode(eventDataContainer)
            print(jsonData)
            
            isLoading = true
            errorMessage = nil
            let accessToken = UserAccountManager.shared.currentUserAccount?.credentials.accessToken
            let instanceURL = UserAccountManager.shared.currentUserAccount?.credentials.instanceUrl
            
            print("Access Token:  \(accessToken!)")
            print("Instance URL : \(instanceURL!.absoluteString)")
            
            let baseURL = instanceURL!.absoluteString
            let path = "/services/apexrest/gameevent/"
            
//            let request = RestRequest.customUrlRequest(with: .POST, baseURL: baseURL, path: path, queryParams: nil)
            let request = RestRequest.customUrlRequest(with: .POST, baseURL: baseURL, path: path, queryParams: nil)
            request.setHeaderValue("Bearer " + accessToken!, forHeaderName: "Authorization")
            request.setHeaderValue("application/json", forHeaderName: "Content-Type")
            request.setCustomRequestBodyData(jsonData, contentType: "application/json")
            
            RestClient.shared.send(request: request, { [weak self] (result) in
                switch result {
                    case .success(let response):
                        print(result)
                        print("-------- response Start ----------")
                        DispatchQueue.main.async {
                            self?.isRequestInProgress = false
                            self?.buttonText = "New Round"
                        }
                        print(response.asString())
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.isRequestInProgress = false
                            self?.buttonText = "New Round"
                        }
                    
                        print(error)
                }
                
                
            })
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }


        
        
        
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


extension Date {
    func toISO8601Format() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        formatter.locale = Locale(identifier: "en_US_POSIX") // POSIX locale to ensure consistent formatting
        return formatter.string(from: self)
    }
}
