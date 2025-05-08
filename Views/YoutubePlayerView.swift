//
//  YoutubePlayer.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 12/26/24.
//

import SwiftUI
import WebKit
import UIKit

struct YouTubePlayerViewer: UIViewRepresentable {
    let videoID: String
    let videoTime: Int
    
    @Binding var isPresented: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1&controls=1&autoplay=1&enablejsapi=1") else {
            return
        }
        let request = URLRequest(url: url)
        uiView.load(request)
        //Max video 5min
        DispatchQueue.main.asyncAfter(deadline: .now()+300, execute: {
            isPresented.toggle()
        })
    }
}

struct YoutubePlayerView: View {
    @Binding var isPresented: Bool
    var bonVideoId: String
    let gradient = LinearGradient(colors: [.orange, .black],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    var body: some View {
        ZStack {
            Image("geometryImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Text("Hello, Lennie! videID=\(bonVideoId)")
                YouTubePlayerViewer(videoID: bonVideoId, videoTime: 20, isPresented: $isPresented)
                    .frame(width: 380, height: 380)
                    .cornerRadius(10)
                    .shadow(radius: 20)
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Back to Game")
                        .padding()
                        .background {
                            Capsule()
                                .stroke(gradient, lineWidth: 3.5)
                                .saturation(1.8)
                        }
                        .font(.system(size: 30))
                        .foregroundColor(Color.black)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    YoutubePlayerView(isPresented: .constant(true), bonVideoId: "3RBnvv_82R0")
}
