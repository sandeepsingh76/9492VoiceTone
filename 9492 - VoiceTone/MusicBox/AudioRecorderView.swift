import SwiftUI

struct AudioRecorderView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AudioRecorderViewModel()
    @StateObject private var playerViewModel = AudioPlayerViewModel()
    @State private var showDetails = false
    @State private var pulseAnimation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    recordingVisualizer
                    
                    recordButton
                    
                    if let url = viewModel.recordedURL, !viewModel.isRecording {
                        playbackControls
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("Record Audio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showDetails) {
                if let url = viewModel.recordedURL {
                    MusicDetailsView(audioURL: url)
                }
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                AppTheme.appBackground,
                AppTheme.surface,
                viewModel.isRecording ? Color.red.opacity(0.14) : Color.blue.opacity(0.16)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.5), value: viewModel.isRecording)
    }
    
    private var recordingVisualizer: some View {
        ZStack {
            if viewModel.isRecording {
                Circle()
                    .stroke(Color.red.opacity(0.2), lineWidth: 3)
                    .frame(width: 200, height: 200)
                    .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                    .opacity(pulseAnimation ? 0 : 1)
                    .animation(.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: pulseAnimation)
                
                Circle()
                    .stroke(Color.red.opacity(0.3), lineWidth: 3)
                    .frame(width: 180, height: 180)
                    .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                    .opacity(pulseAnimation ? 0 : 1)
                    .animation(.easeOut(duration: 1.5).repeatForever(autoreverses: false).delay(0.3), value: pulseAnimation)
            }
            
            ZStack {
                Circle()
                    .fill(.linearGradient(
                        colors: viewModel.isRecording ? [.red, .orange] : [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 160, height: 160)
                    .shadow(color: (viewModel.isRecording ? Color.red : Color.blue).opacity(0.4), radius: 30, x: 0, y: 15)
                
                Image(systemName: viewModel.isRecording ? "waveform" : "mic.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            pulseAnimation = true
        }
    }
    
    private var recordButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                if viewModel.isRecording {
                    viewModel.stopRecording()
                } else {
                    viewModel.startRecording()
                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "circle.fill")
                    .font(.title3)
                
                Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: viewModel.isRecording ? [.red, .orange] : [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: (viewModel.isRecording ? Color.red : Color.blue).opacity(0.3), radius: 15, x: 0, y: 8)
        }
    }
    
    private var playbackControls: some View {
        VStack(spacing: 16) {
            Text("Recording Complete")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                Button(action: {
                    if let url = viewModel.recordedURL {
                        playerViewModel.playAudio(url: url)
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: playerViewModel.isPlaying ? "pause.fill" : "play.fill")
                            .font(.headline)
                        Text(playerViewModel.isPlaying ? "Pause" : "Preview")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.green, .teal],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 6)
                }
                
                Button(action: {
                    playerViewModel.stopAudio()
                    showDetails = true
                }) {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .orange.opacity(0.3), radius: 12, x: 0, y: 6)
                }
            }
        }
    }
}
