//
//  SettingsView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/21/24.
//

import SwiftUI
import PhotosUI

struct GearView: View {
    @State private var photosPickerItems: [PhotosPickerItem] = []
    var body: some View {
        HStack {
            Spacer()            
            VStack {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(Color(.label))
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
                Spacer()
            }
        }
        .padding()
    }
}



struct LoadedImagesView: View {
    var selectedImages: [UIImage] = []
    var body: some View {
        if !selectedImages.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedImages, id: \.self) {image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

#Preview {
    GearView()
//        LoadedImagesView(selectedImages: [UIImage(named: "DefaultImage1.jpg")!, UIImage(named: "DefaultImage2.jpg")!, UIImage(named: "Loading.jpg")!, UIImage(named: "DefaultImage3.jpg")!, UIImage(named: "DefaultImage4.jpg")!,UIImage(named: "DefaultImage5.jpg")!, UIImage(named: "DefaultImage6.jpg")!,UIImage(named: "DefaultImage7.jpg")!, UIImage(named: "DefaultImage8.jpg")!, ])
}
