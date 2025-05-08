//
//  HeaderView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/19/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct HeaderView: View {
    @StateObject var PPviewModelHeader: PhotoPickerViewModal
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.pink)
                .rotationEffect(Angle(degrees: 15))
            VStack {
                //                SettingsView()
                HStack() {
                    PhotosPicker(selection: $PPviewModelHeader.imageSelections,maxSelectionCount: 50, matching: .any(of: [.images, .screenshots, .panoramas, .bursts, .livePhotos])) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color(.white))
                            .imageScale(.large)
                            .frame(width: 64, height: 64)
                    }
                }
                .offset(x: UIScreen.main.bounds.width-230, y: 15 )

                Text("Multiply Me")
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .bold()
                
                Text("Multiplication puzzle game")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.top, 10)
        }
        .frame(width: UIScreen.main.bounds.width*3, height: 320)
        .offset(y: -120)
    }
}


#Preview {
    HeaderView(PPviewModelHeader: PhotoPickerViewModal())
}
