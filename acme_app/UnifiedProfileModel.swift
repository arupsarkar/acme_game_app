//
//  UnifiedProfileModel.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/11/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import Foundation
import SmartStore
import SalesforceSDKCore

struct ProfileData: Codable {
    var FirstName: String
    var LastName: String
    var UnifiedId: String
    var Phones: [String]
    var Emails: [String]
    var PhotoUrl: String
}

struct User: Codable {
    var UnifiedId: String
    var PhotoUrl: String
    var Phones: [Phone]
    var LastName: String
    var FirstName: String
    var Emails: [Email]

    enum CodingKeys: String, CodingKey {
        case UnifiedId = "UnifiedId"
        case PhotoUrl = "PhotoUrl"
        case Phones = "Phones"
        case LastName = "LastName"
        case FirstName = "FirstName"
        case Emails = "Emails"
    }
}

struct Phone: Codable {
    var Phone: String

    enum CodingKeys: String, CodingKey {
        case Phone = "Phone"
    }
}

struct Email: Codable {
    var Email: String

    enum CodingKeys: String, CodingKey {
        case Email = "Email"
    }
}

class UnifiedProfileViewModel: ObservableObject {
    @Published var profileData: ProfileData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var result: String?
    @Published var userData: [User]?
    @Published var buttonText = "Refresh Data"
    
    var store: SmartStore?
    
    init() {
        store = SmartStore.shared(withName: SmartStore.defaultStoreName)
        print(store!)
    }
    
    func fetchUnifiedProfileData() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.buttonText = "Request in progress.."
        }
//        isLoading = true
        errorMessage = nil
        let accessToken = UserAccountManager.shared.currentUserAccount?.credentials.accessToken
        let instanceURL = UserAccountManager.shared.currentUserAccount?.credentials.instanceUrl
        
        print("Access Token:  \(accessToken!)")
        print("Instance URL : \(instanceURL!.absoluteString)")

        let baseURL = "https://tinkerlab-sdo-cdp.my.salesforce.com"
        let path = "/services/apexrest/unifiedprofile/" + "2c1b2a8da0a7c6232f758c8a79eb3060"
//        let apexResourcePath = "https://tinkerlab-sdo-cdp.my.salesforce.com/services/apexrest/unifiedprofile/" + "2c1b2a8da0a7c6232f758c8a79eb3060"

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
                    //let users = try JSONDecoder().decode([User].self, from: response.asData())
                    self?.userData = try JSONDecoder().decode([User].self, from: response.asData())
                    print(self?.userData?[0].FirstName as Any)
                    print(self?.userData?[0].LastName as Any)
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.buttonText = "Refresh Data"
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.buttonText = "Refresh Data"
                    }
                }
                print("-------- response End ----------")
            case .failure( let error ):
                print(error)
            }
            
        })

        
        
//        let url = URL(string: "https://tinkerlab-sdo-cdp.my.salesforce.com" + "/services/apexrest/unifiedprofile/" + "2c1b2a8da0a7c6232f758c8a79eb3060")!
//        print("Instance URL : \(url)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                if let data = data {
//                    do {
//                        print(response as Any)
//                        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//                        print("Body: \(strData)")
//                      let decodedData = try JSONDecoder().decode(ProfileData.self, from: data)
//                        self.profileData = decodedData
//                    } catch {
//                        self.errorMessage = "Failed to decode response"
//                    }
//                } else if error != nil {
//                    self.errorMessage = "Failed to fetch data"
//                }
//            }
//        }.resume()
        
    }
}
