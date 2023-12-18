//
//  ConsentDataView.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/13/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import SwiftUI


struct EmailDataRowView: View {
    let explanation: Explanation
    
    var body: some View {
        HStack {
            Text(explanation.field)
            Spacer()
            Text(explanation.value)
        }
    }
}

struct ConsentDataView: View {
    @ObservedObject var viewModel = ConsentDataModel()
//    let emailData: [String: EmailData]
    
    var body: some View {

        VStack {
            if viewModel.isLoading {
                ProgressView()
            }else if let consentData = viewModel.consentData {
                ScrollView {
                    if let proceedData = viewModel.proceedData {
//                        GroupBox(label: 
//                                    Text("Proceed")
//                            .frame(maxWidth: .infinity, alignment: .center)
//                        ) {
//                            VStack(alignment: .leading) {
//                                Text("Geotrack Result: \(proceedData.geotrackResult)")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .font(.system(size: 10))
//                                Text("Geotrack: \(proceedData.geotrack)")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .font(.system(size: 10))
//                                Text("Solicit Result: \(proceedData.solicitResult)")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .font(.system(size: 10))
//                                Text("solicit: \(proceedData.solicit)")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .font(.system(size: 10))
//                                Text("Process Result: \(proceedData.processResult)")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .font(.system(size: 10))
//                                Text("Process: \(proceedData.process)")
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .font(.system(size: 10))
//                            }
//                        }
                    }
                    GroupBox(
                        label: Text("Explanation")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                            
                    ){
                        ForEach(viewModel.explanationData){ consent in
                            HStack{
                                Text(consent.objectConsulted)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 10))
                                Text(consent.field)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 10))
                                Text(consent.value)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 10))
                            }
                        }
                    }



                }
            }
        }
        
        Button(action: {
            // Action for the button
            viewModel.fetchConsentData()
        }) {
            Text("Consent Preferences")
                .font(.system(size: 12)) // Small font size
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)) // Compact padding
                .background(Color.blue) // Background color
                .foregroundColor(.white) // Text color
                .cornerRadius(5) // Rounded corners
        }
    }


}
