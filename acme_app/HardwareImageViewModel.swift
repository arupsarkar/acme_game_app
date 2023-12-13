//
//  HardwareImageViewModel.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/12/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import Foundation


struct HardwareImage: Identifiable {
    let id = UUID()
    var url: URL
}

class HardwareImageViewModel: ObservableObject {
    @Published var images: [HardwareImage] = []

    func fetchImages() {
        // Fetch random hardware images from an API
        // This is a simplified example. In a real app, you would make an actual network request here.
        for _ in 1...6 {
            if let url = URL(string: "https://source.unsplash.com/random/300x300?computer") {
                let image = HardwareImage(url: url)
                images.append(image)
            }
        }
    }
}
