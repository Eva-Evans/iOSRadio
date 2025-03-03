//
//  MiniPlayerView.swift
//  RadioSUI
//
//  Created by Александр Иванов on 03.03.2025.
//

import SwiftUI
import MediaPlayer
import SwiftUI
import AVKit

struct MiniPlayerView: View {
    let efir: EfirM
    @ObservedObject var radioPlayer: RadioPlayer
    
    var body: some View {
        HStack {
            AsyncImage(url: efir.imageUrl) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "radio")
                    .resizable()
            }
            .frame(width: 40, height: 40)
            .cornerRadius(5)
            
            Text(efir.name)
                .font(.headline)
                .lineLimit(1)
            
            Spacer()
            
    
            Button(action: {
                if radioPlayer.isPlaying {
                    radioPlayer.stop()
                } else {
                    radioPlayer.play(efir)
                }
            }) {
                Image(systemName: radioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
            }
            
    
            Button(action: {
                let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
                let airplayView = AVRoutePickerView(frame: rect)
                airplayView.tintColor = .blue
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.addSubview(airplayView)
                }
            }) {
                Image(systemName: "airplayaudio")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
