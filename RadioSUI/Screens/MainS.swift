//
//  ContentView.swift
//  RadioSUI
//  Created by brfsu on 24.04.2024.
//
import SwiftUI

struct MainS: View {
    @StateObject var radioPlayer = RadioPlayer.instance
    @StateObject var fetcher = RadioFetcher.shared
    @State var status = NSLocalizedString("select_radio_station", comment: "")
    
    var body: some View {
        if fetcher.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            if fetcher.efirs.count > 0 {
                Button {
                    playPause(efir: radioPlayer.efir)
                } label: {
                    Text(status)
                }
            }
            TabView {
                if fetcher.efirs.count > 0 {
                    List{ ForEach(fetcher.efirs) { efir in
                        ZStack {
                            EfirV(efir: efir)
                                .listRowSeparator(.hidden)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(efir.randomColor, lineWidth: 5)
                                )
                                .padding(.horizontal)
                                .padding(.bottom)
                                .onTapGesture {
                                    playPause(efir: efir)
                                }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ButtonHeartV(efir: efir)
                                        .padding()
                                }
                                
                            }
                        }
                    }
                    .onDelete(perform: fetcher.removeEfir) // Удаление смахиванием
                        
                    .tabItem {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                        Text(NSLocalizedString("radios", comment: ""))
                    }
                        
                    .refreshable {
                        fetcher.load()
                    }
                    } }else {
                        Text(NSLocalizedString("no_radios", comment: ""))
                }
                
                // Миниплейер
                
                if fetcher.favEfirs.count > 0 {
                    List(fetcher.favEfirs) { efir in
                        ZStack {
                            EfirV(efir: efir)
                                .listRowSeparator(.hidden)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(efir.randomColor, lineWidth: 5)
                                )
                                .padding(.horizontal)
                                .padding(.bottom)
                                .onTapGesture {
                                    playPause(efir: efir)
                                }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ButtonHeartV(efir: efir)
                                        .padding()
                                }
                            }
                        }
                    }
                    
                    
                    .tabItem {
                        Image(systemName: "heart")
                        Text(NSLocalizedString("favorites", comment: ""))
                    }
                    
                    if let efir = radioPlayer.efir, radioPlayer.isPlaying {
                        MiniPlayerView(efir: efir, radioPlayer: radioPlayer)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .onTapGesture {
                        // Открыть приложение при нажатии на миниплейер
                            // (если приложение свернуто)
                        }
                    }
                }
            }
        }
    }
    
    
    private func playPause(efir: EfirM?) {
        if let efir = efir {
            if efir != radioPlayer.efir {
                radioPlayer.initPlayer(url: efir.streamUrl)
                radioPlayer.play(efir)
                status = String(format: NSLocalizedString("playing", comment: ""), efir.name)
            } else {
                if !radioPlayer.isPlaying {
                    radioPlayer.play(efir)
                    status = String(format: NSLocalizedString("playing", comment: ""), efir.name)
                } else {
                    radioPlayer.stop()
                    status = String(format: NSLocalizedString("paused", comment: ""), efir.name)
                }
            }
        }
    }
    
    
    @ViewBuilder func ButtonHeartV(efir: EfirM) -> some View {
        Button(action: {
            withAnimation {
                if fetcher.favEfirs.contains(efir) {
                    fetcher.favDel(efir: efir)
//                    fetcher.favEfirs.removeAll() { $0 == efir }
                } else {
                    fetcher.favAdd(efir: efir)
//                    fetcher.favEfirs.append(efir)
                }
                fetcher.saveFavourites(fetcher.favEfirs)
            }
        }) {
            Image(systemName: fetcher.favEfirs.contains(efir) ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .padding()
                .foregroundColor(fetcher.favEfirs.contains(efir) ? .red : .brown)
                .background(Circle().fill(Color.white))
                .shadow(radius: 3)
                .accessibility(label: Text(fetcher.favEfirs.contains(efir) ? "Remove from favourites" : "Add into favourites"))
        }
    }
}
