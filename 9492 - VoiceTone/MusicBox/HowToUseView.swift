import SwiftUI

struct HowToUseView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Hero Section
            VStack(spacing: 12) {
                Image(systemName: "music.note.house.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .padding(.top, 20)
                
                Text("Welcome to MusicBox")
                    .font(.title2.bold())
                
                Text("Your personal music recording studio")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(AppTheme.surface)
            
            // Tab Selector
            Picker("Guide Type", selection: $selectedTab) {
                Text("Quick Start").tag(0)
                Text("Features").tag(1)
                Text("Tips").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Content
            TabView(selection: $selectedTab) {
                QuickStartView()
                    .tag(0)
                
                FeaturesView()
                    .tag(1)
                
                TipsView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(AppTheme.appBackground.ignoresSafeArea())
        .navigationTitle("How to Use")
        .navigationBarTitleDisplayMode(.inline)
        .musicBoxCustomBackButton()
    }
}

// MARK: - Quick Start
struct QuickStartView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                StepCard(
                    number: 1,
                    title: "Start Recording",
                    description: "Tap the '+' button on the Music tab to begin recording",
                    icon: "plus.circle.fill",
                    color: .blue
                )
                
                StepCard(
                    number: 2,
                    title: "Record Your Audio",
                    description: "Press the record button and start playing or singing",
                    icon: "waveform.circle.fill",
                    color: .green
                )
                
                StepCard(
                    number: 3,
                    title: "Save & Name",
                    description: "Stop recording, add a title and description, then save",
                    icon: "square.and.arrow.down.fill",
                    color: .orange
                )
                
                StepCard(
                    number: 4,
                    title: "Play & Enjoy",
                    description: "Tap any recording from your list to play it back",
                    icon: "play.circle.fill",
                    color: .purple
                )
            }
            .padding()
        }
    }
}

// MARK: - Features
struct FeaturesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                FeatureCard(
                    icon: "mic.fill",
                    title: "High-Quality Recording",
                    description: "Record audio in multiple quality settings",
                    color: .red
                )
                
                FeatureCard(
                    icon: "music.note.list",
                    title: "Music Library",
                    description: "All your recordings organized in one place",
                    color: .blue
                )
                
                FeatureCard(
                    icon: "play.circle.fill",
                    title: "Easy Playback",
                    description: "Play, pause, and seek through recordings",
                    color: .green
                )
                
                FeatureCard(
                    icon: "pencil.circle.fill",
                    title: "Edit Details",
                    description: "Update title and description anytime",
                    color: .orange
                )
                
                FeatureCard(
                    icon: "trash.fill",
                    title: "Manage Storage",
                    description: "Delete unwanted recordings to free up space",
                    color: .pink
                )
                
                FeatureCard(
                    icon: "gearshape.fill",
                    title: "Customizable Settings",
                    description: "Adjust audio quality, notifications, and appearance",
                    color: .purple
                )
            }
            .padding()
        }
    }
}

// MARK: - Tips
struct TipsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TipCard(
                    icon: "lightbulb.fill",
                    title: "Best Recording Quality",
                    tip: "Record in a quiet environment for clearer audio",
                    color: .yellow
                )
                
                TipCard(
                    icon: "speaker.wave.3.fill",
                    title: "Check Volume",
                    tip: "Ensure your device volume is up before recording",
                    color: .blue
                )
                
                TipCard(
                    icon: "folder.fill",
                    title: "Organize Your Music",
                    tip: "Use descriptive titles to easily find recordings later",
                    color: .green
                )
                
                TipCard(
                    icon: "arrow.clockwise",
                    title: "Auto-Save Feature",
                    tip: "Enable auto-save in settings to never lose recordings",
                    color: .orange
                )
                
                TipCard(
                    icon: "externaldrive.fill",
                    title: "Manage Storage",
                    tip: "Regularly delete old recordings to free up space",
                    color: .red
                )
            }
            .padding()
        }
    }
}

// MARK: - Components
struct StepCard: View {
    let number: Int
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.gradient)
                    .frame(width: 60, height: 60)
                
                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.title3)
                    Text("\(number)")
                        .font(.caption2.bold())
                }
                .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(AppTheme.surface)
        .cornerRadius(16)
        .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color.gradient)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(AppTheme.surface)
        .cornerRadius(16)
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let tip: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.15))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(tip)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(AppTheme.surface)
        .cornerRadius(16)
    }
}
