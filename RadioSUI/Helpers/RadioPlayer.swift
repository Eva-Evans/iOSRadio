//
//  RadioPlayer.swift
//  RadioSUI
//  Created by brfsu on 24.04.2024.
//
import MediaPlayer
import AVKit

class RadioPlayer: ObservableObject {
    static let instance = RadioPlayer()
    var player = AVPlayer()


    @Published var isPlaying = false
    @Published var efir: EfirM? = nil
    
    init() {
        setupAudioSession()
        setupRemoteCommandCenter()
    }
        
    private func setupAudioSession() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to set up audio session: \(error)")
            }
        }
    
    
    func initPlayer(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }

    func play(_ efir: EfirM) {
        self.efir = efir
        player.volume = 1
        player.play()
        isPlaying = true
    }
    
    func stop() {
        isPlaying = false
        player.pause()
    }
    
    
    private func setupRemoteCommandCenter() {
            let commandCenter = MPRemoteCommandCenter.shared()
            
            commandCenter.playCommand.addTarget { [unowned self] _ in
                if let efir = self.efir {
                    self.play(efir)
                }
                return .success
            }
            
            commandCenter.pauseCommand.addTarget { [unowned self] _ in
                self.stop()
                return .success
            }
        }
    
    private func setupNowPlaying(efir: EfirM) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = efir.name
        
        // Загрузка изображения для миниплейера
        if let imageData = try? Data(contentsOf: efir.imageUrl),
           let image = UIImage(data: imageData) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
        } else {
            // Если изображение не загружено, используем дефолтное
            let defaultImage = UIImage(systemName: "radio") ?? UIImage()
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: defaultImage.size) { _ in
                return defaultImage
            }
        }
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
}
