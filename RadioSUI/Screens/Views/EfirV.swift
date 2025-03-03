//
//  EfirV.swift
//  RadioSUI
//  Created by brfsu on 24.04.2024.
//
import SwiftUI

struct EfirV: View
{
    let efir: EfirM
    
    @StateObject var radioPlayer = RadioPlayer.instance
    
    var body: some View {
        ZStack {
            AsyncImage(url: efir.imageUrl)
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.size.width - 45, height: UIScreen.main.bounds.size.width - 45)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            VStack {
                Text(efir.name)
                    .frame(maxWidth: .infinity)
                    .font(.title)
                    .bold()
                    .padding()
                    .background(efir.randomColor)
                    .cornerRadius(10)
                    .lineLimit(2)
                    .shadow(radius: 5)
                
                Spacer()
                
                Text(radioPlayer.efir == efir && radioPlayer.isPlaying ? "Pause" : "Play")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
    }
}
