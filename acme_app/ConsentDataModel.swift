//
//  ConsentDataModel.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/13/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore

struct EmailData: Codable {
    let result: String
    let proceed: Proceed
    let explanation: [Explanation]
    
    enum CodingKeys: String, CodingKey {
        case result
        case proceed
        case explanation
    }
}

struct Proceed: Codable {
    let geotrackResult: String
    let geotrack: String
    let solicitResult: String
    let solicit: String
    let processResult : String
    let process : String
    let profileResult : String
    let profile : String
    let trackResult : String
    let track : String
    let piiResult : String
    let pii : String
    let portabilityResult : String
    let portability : String
    let forgetResult : String
    let forget : String
    let emailResult : String
    let email : String
    let faxResult : String
    let fax : String
    let phoneResult : String
    let phone : String
    let socialResult : String
    let social : String
    let mailResult : String
    let mail : String
    let webResult : String
    let web : String

    enum CodingKeys: String, CodingKey {
        case geotrackResult
        case geotrack
        case solicitResult
        case solicit
        case processResult
        case process
        case profileResult
        case profile
        case trackResult
        case track
        case piiResult
        case pii
        case portabilityResult
        case portability
        case forgetResult
        case forget
        case emailResult
        case email
        case faxResult
        case fax
        case phoneResult
        case phone
        case socialResult
        case social
        case mailResult
        case mail
        case webResult
        case web
    }
}

struct Explanation: Codable, Identifiable {
    let id = UUID()
    let objectConsulted: String
    let field: String
    let recordId: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case objectConsulted
        case field
        case recordId
        case value
    }
}

class ConsentDataModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var result: String?
    @Published var consentData: [EmailData]?
    @Published var proceedData: Proceed?
    @Published var explanationData: [Explanation] = []
    
    func fetchConsentData() {
        self.isLoading = true
        let accessToken = UserAccountManager.shared.currentUserAccount?.credentials.accessToken
        let instanceURL = UserAccountManager.shared.currentUserAccount?.credentials.instanceUrl

        let emailId = "j.boise@acme.com"
        let baseURL = instanceURL!.absoluteString
        let path = "/services/data/v59.0/consent/multiaction?actions=email,fax,geotrack,mail,phone,portability,process,profile,shouldforget,social,solicit,storepiielsewhere,track,web&ids=" + emailId + "&verbose=true"
        
        let request = RestRequest.customUrlRequest(with: .GET, baseURL: baseURL, path: path, queryParams: nil)
        request.setHeaderValue("Bearer " + accessToken!, forHeaderName: "Authorization")
        request.setHeaderValue("application/json", forHeaderName: "Content-Type")
        

        print("-------- request Start ----------")
        print(request)
        print("-------- request End ----------")
        
        RestClient.shared.send(request: request, { [weak self] (result) in

            switch result {
            case .success( let response ):
                print(result)
                print("-------- response Start ----------")
                print(response.asString())
                self?.result = response.asString()
                do {
                    let decoder = JSONDecoder()
                    let emailData = try decoder.decode([String: EmailData].self, from: response.asData())
                    self?.consentData = Array(emailData.values)
                    print(self?.consentData![0].result)
                    self?.proceedData = emailData.values.first?.proceed
                    self?.explanationData = self?.consentData![0].explanation ?? []
                    self?.isLoading = false
                    //self?.consentData = try decoder.decode([EmailData].self, from: response.asData())
                } catch {
                    print("Error decoding JSON: \(error)")
                }
                print("-------- response End ----------")
            case .failure( let error ):
                print(error)
            }
            
        })
        
    }

    
}
