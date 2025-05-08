//
//  ImageInCircle.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 4/9/24.
//

import SwiftUI

struct ImageInCircle: View {
    var circleImage: UIImage
    let sizeOfCicle = 250.0
    var body: some View {
        Image(uiImage: circleImage)
        .resizable()
        .frame(width: sizeOfCicle , height: sizeOfCicle)
        .aspectRatio(contentMode: .fit)
        .clipShape(Circle())
        .overlay {
                       Circle().stroke(.black, lineWidth: 1)
                   }
                   .shadow(radius: 7)    }
}

#Preview {
    ImageInCircle(circleImage: UIImage(named: "Loading.jpg")!)
}
