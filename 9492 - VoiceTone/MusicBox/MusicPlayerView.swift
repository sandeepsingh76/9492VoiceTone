import SwiftUI

struct MusicPlayerView: View {
    let musicItem: MusicItem
    @StateObject private var playerViewModel = AudioPlayerViewModel()
    
    var audioURL: URL? {
        guard let audioPath = musicItem.audioPath else { return nil }
        return MusicFileStore.url(forRelativePath: audioPath)
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: 0) {
                Spacer()
                
                albumArtwork
                    .padding(.bottom, 50)
                
                musicInfo
                    .padding(.bottom, 60)
                
                playbackControls
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .musicBoxCustomBackButton()
        .onDisappear {
            playerViewModel.stopAudio()
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                AppTheme.appBackground,
                AppTheme.surface,
                Color.blue.opacity(0.18),
                Color.purple.opacity(0.14)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var albumArtwork: some View {
        Group {
            if let imagePath = musicItem.imagePath, !imagePath.isEmpty {
                CachedArtworkImage(imagePath: imagePath) {
                    artworkPlaceholder
                }
                .frame(width: 320, height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 15)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .scaleEffect(playerViewModel.isPlaying ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: playerViewModel.isPlaying)
            } else {
                artworkPlaceholder
                .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 15)
            }
        }
    }

    private var artworkPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.linearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 320, height: 320)

            Image(systemName: "music.note")
                .font(.system(size: 100))
                .foregroundStyle(.linearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        }
    }
    
    private var musicInfo: some View {
        VStack(spacing: 12) {
            Text(musicItem.name ?? "Untitled")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(musicItem.composers ?? "Unknown Artist")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
    }
    
    private var playbackControls: some View {
        HStack(spacing: 40) {
            Button(action: {}) {
                Image(systemName: "backward.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.secondary)
            }
            .disabled(true)
            .opacity(0.3)
            
            Button(action: {
                if let url = audioURL {
                    playerViewModel.playAudio(url: url)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(.linearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 80, height: 80)
                        .shadow(color: .blue.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: playerViewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .offset(x: playerViewModel.isPlaying ? 0 : 2)
                }
            }
            .scaleEffect(playerViewModel.isPlaying ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: playerViewModel.isPlaying)
            
            Button(action: {}) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.secondary)
            }
            .disabled(true)
            .opacity(0.3)
        }
    }
}
