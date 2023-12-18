//
//  MerchandiseView.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/11/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SalesforceSDKCore

struct MerchandiseView: View {
    @ObservedObject var viewModel = SalesOrderModel()

    var body: some View {
        
        
        VStack {
            Text("Merchandise")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(Color.clear)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.blue]), startPoint: .leading, endPoint: .trailing)
                        .mask(
                            Text("Merchandise")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        )
                )
            
            GroupBox (
                label: Text("Items in the Cart")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            ){
                VStack {
                    HStack{
                        AsyncImageView(url: URL(string: "https://source.unsplash.com/random/300x300?computer")!,imageSize: 50)
                            .padding(.trailing)
                        Text("Starter Kit")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 15))
                        Text("$12.99")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 15))
                        Button(action: {
                            // Action for the button
                            print("Buy button tapped")
                        }) {
                            Text("Buy")
                                .font(.system(size: 12)) // Small font size
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)) // Compact padding
                                .background(Color.blue) // Background color
                                .foregroundColor(.white) // Text color
                                .cornerRadius(5) // Rounded corners
                        }
                    }

                    HStack {
                        AsyncImageView(url: URL(string: "https://source.unsplash.com/random/300x300?computer")!,imageSize: 50)
                            .padding(.trailing)
                        Text("Energy Meter")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 15))
                        Text("$89.99")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 15))
                        Button(action: {
                            // Action for the button
                            print("Buy button tapped")
                        }) {
                            Text("Buy")
                                .font(.system(size: 12)) // Small font size
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)) // Compact padding
                                .background(Color.blue) // Background color
                                .foregroundColor(.white) // Text color
                                .cornerRadius(5) // Rounded corners
                        }
                    }

                    HStack {
                        AsyncImageView(url: URL(string: "https://source.unsplash.com/random/300x300?computer")!,imageSize: 50)
                            .padding(.trailing)
                        Text("GPU Graphic Memory(RAM)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 15))
                        Text("$169.99")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 15))
                        Spacer()
                        Button(action: {
                            // Action for the button
                            print("Buy button tapped")
                        }) {
                            Text("Buy")
                                .font(.system(size: 12)) // Small font size
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)) // Compact padding
                                .background(Color.blue) // Background color
                                .foregroundColor(.white) // Text color
                                .cornerRadius(5) // Rounded corners
                        }
                    }


                }

            }
            
            // Show the list of sales orders from the platform
            GroupBox (
                label: Text("Recent Orders")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            ){
                List(viewModel.salesOrders) { dataItem in
                    VStack {
                            HStack {
                                AsyncImageView(url: URL(string: "https://source.unsplash.com/random/300x300?computer")!,imageSize: 50)
                                    .padding(.trailing)
                                Text(dataItem.Name ?? "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 15))
                                Text(dataItem.Name__c ?? "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 15))
                                Text(formatAsCurrency(Decimal(dataItem.GrandTotalAmount__c ?? 0.00)))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 15))
                            }

                        }
                }
                .onAppear(perform: self.viewModel.fetchSalesOrders)
            }
            // button to refresh the salesforce when a sales is made from the platform
            Button(action: {
                viewModel.fetchSalesOrders()
            }) {
                Text("Refresh Data")
                    .fontWeight(.bold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .padding(.horizontal)
            }
        }

        
    }
    
    func currencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }
    func formatAsCurrency(_ value: Decimal) -> String {
        let formatter = currencyFormatter()
        return formatter.string(from: value as NSNumber) ?? "$0.00"
    }


    
}

struct Merchandise_Previews: PreviewProvider {
  static var previews: some View {
      MerchandiseView()
  }
    
}


struct BorderedGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
                .padding(.bottom, 1)
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
    }
}
