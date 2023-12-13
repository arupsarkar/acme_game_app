//
//  SalesOrderModel.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/12/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import Combine

struct SalesOrder:  Hashable, Identifiable, Decodable  {
    let id: UUID = UUID()
    let Id: String
    let Name: String?
    let GrandTotalAmount__c: Double?
    let Name__c: String?
}


struct QueryResponse: Decodable {
    var totalSize: Int
    var done: Bool
    var records: [SalesOrder]
}


class SalesOrderModel: ObservableObject {
    @Published var salesOrders: [SalesOrder] = []
    private var salesOrderCancellable: AnyCancellable?
    private let orderStatus = "Completed"
    
    
    func fetchSalesOrders(){
        let request = RestClient.shared.request(forQuery: "SELECT Id, Name, GrandTotalAmount__c, Name__c FROM Sales_Orders__c WHERE SalesOrderStatusId__c = 'Completed' ORDER BY CreatedDate DESC LIMIT 3", apiVersion: nil)

        salesOrderCancellable = RestClient.shared.publisher(for: request)
            .receive(on: RunLoop.main)
            .tryMap({ (response) -> Data in
                response.asData()
            })
            .decode(type: QueryResponse.self, decoder: JSONDecoder())
            .map({ (record) -> [SalesOrder] in
                record.records
            })
            .catch( { error in
                Just([])
            })
            .assign(to: \.salesOrders, on:self)
    }

    

    
}
