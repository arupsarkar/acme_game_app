//
//  UnifiedProfileView.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/11/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import SwiftUI

struct UnifiedProfileView: View {
    @ObservedObject var viewModel = UnifiedProfileViewModel()
    
    var body: some View {
        
        
        VStack {
            if viewModel.isLoading {
                ProgressView()
//            } else if let data = viewModel.result {
//                Text("Data: \(data)")
            } else if let userData = viewModel.userData {
                Text("Name: \(userData[0].FirstName) \(userData[0].LastName)")
                List(userData, id: \.UnifiedId) { user in
                    VStack(alignment: .center, spacing: 5) {
                        Text("\(user.FirstName) \(user.LastName)")
                            .font(.headline)
                            .padding(.top)
                        
                        // Profile Image
                        if let imageUrl = URL(string: user.PhotoUrl), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                .padding(.bottom, 10)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                        }
                        
                        GroupBox(
                            label: Text("Phones")
                                .frame(maxWidth: .infinity, alignment: .center)
                        ) {
                            ForEach(user.Phones, id: \.Phone) { phone in
                                HStack {
                                    Label(phone.Phone.dropFirst().dropLast(), systemImage: "phone")
                                }
                                .padding(.vertical, 2)
                                

                            }
                        }
                        
                        GroupBox(
                            label: Text("Emails")
                                .frame(maxWidth: .infinity, alignment: .center)
                        ) {
                            ForEach(user.Emails, id: \.Email) { email in
                                
                                HStack {
                                    Label(email.Email.dropFirst().dropLast(), systemImage: "envelope")
                                        .padding(.leading)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    // consent data
                    GroupBox(
                        label: Text("Consent Data")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                    ) {
                        ConsentDataView()
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            }
            

            
            Button(action: {
                viewModel.fetchUnifiedProfileData()
            }) {
                Text(viewModel.buttonText)
                    .fontWeight(.bold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .padding(.horizontal)
            }
            .disabled(viewModel.isLoading)

        }
//        .onAppear {
//            viewModel.fetchUnifiedProfileData()
//        }
    }
}

//#Preview {
//    UnifiedProfileView()
//}
