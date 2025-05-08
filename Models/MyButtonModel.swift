//
//  MyButtonModel.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/20/24.
//

import SwiftUI
struct MyButtonStyle: PrimitiveButtonStyle {
    var color: Color

    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        MyButton(configuration: configuration, color: color)
    }
    struct MyButton: View {
        @State private var pressed = false
        let configuration: PrimitiveButtonStyle.Configuration
        let color: Color


        var body: some View {

            return configuration.label
                .foregroundColor(.white)
//                .padding(15)
                .background(RoundedRectangle(cornerRadius: 1).fill(color))
                .compositingGroup()
                .shadow(color: .black, radius: 3)
                .opacity(self.pressed ? 0.8 : 1.0)
                .scaleEffect(self.pressed ? 0.9 : 1.0)
                .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 1)) {
                    self.pressed = pressing
//                        print("call: \(GamificationView().environmentObject(UserData().username))")
                }
//                    if pressing {
//                            print("col: \(col)")
//
//                    } else {
//                        print("My long pressed ends")
//
//                    }
            }, perform: { })
        }
    }
}
struct MyButtonModel: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button{
            
        }label: {
            Text("My Button")
                
        }
        .buttonStyle(MyButtonStyle(color: .black))
        .frame(minWidth: 200, maxWidth: 200)
        .clipShape(Circle().stroke(lineWidth: 200))
        
        .padding()
    }
}

#Preview {
    MyButtonModel()
}

