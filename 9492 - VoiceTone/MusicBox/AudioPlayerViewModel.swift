import Foundation
import AVFoundation
import Combine

class AudioPlayerViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    private var audioPlayer: AVAudioPlayer?
    
    func playAudio(url: URL) {
        if let currentPlayer = audioPlayer, currentPlayer.url == url {
            if currentPlayer.isPlaying {
                currentPlayer.pause()
                isPlaying = false
            } else {
                currentPlayer.play()
                isPlaying = true
            }
            return
        }
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
        
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.delegate = self
        audioPlayer?.play()
        isPlaying = true
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
