//
//  AsyncImageView.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/12/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import SwiftUI

struct AsyncImageView: View {
    @State private var data: Data?

    let url: URL
    let imageSize: CGFloat
    
    init(url: URL, imageSize: CGFloat = 50) {
        self.url = url
        self.imageSize = imageSize
    }

    var body: some View {
        if let data = data, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
        } else {
            Circle()
                .fill(Color.gray)
                .frame(width: imageSize, height: imageSize)
                .onAppear {
                    fetchData()
                }
        }
    }

    private func fetchData() {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
}

//#Preview {
//    AsyncImageView(url: <#URL#>)
//}
