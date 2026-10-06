import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest
    private var musicItems: FetchedResults<MusicItem>
    
    @State private var showRecorder = false

    init() {
        let request: NSFetchRequest<MusicItem> = MusicItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MusicItem.createdAt, ascending: false)]
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = true
        _musicItems = FetchRequest(fetchRequest: request, animation: .spring(response: 0.4, dampingFraction: 0.8))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.appBackground.ignoresSafeArea()
                
                if musicItems.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(musicItems, id: \.objectID) { item in
                                NavigationLink(destination: MusicPlayerView(musicItem: item)) {
                                    CDCaseView(musicItem: item)
                                        .padding(.horizontal, 20)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("My Music")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showRecorder = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                }
            }
            .sheet(isPresented: $showRecorder) {
                AudioRecorderView()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(.linearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "music.note.list")
                    .font(.system(size: 50))
                    .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            
            Text("No Music Yet")
                .font(.title2.bold())
            
            Text("Tap + to record your first track")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            offsets.map { musicItems[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

struct CDCaseView: View {
    let musicItem: MusicItem
    
    var body: some View {
        ZStack {
            // CD Case spine/edge
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.15))
                .frame(height: 180)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
            
            // CD disc visible at top
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.3), Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                        center: .center,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                .overlay(
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 40, height: 40)
                )
                .offset(y: -60)
            
            // Album artwork in CD center
            if let imagePath = musicItem.imagePath, !imagePath.isEmpty {
                CachedArtworkImage(imagePath: imagePath) {
                    Circle()
                        .fill(Color.clear)
                }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 2))
                    .offset(y: -60)
            }
            
            // Text labels
            VStack(spacing: 4) {
                Text(musicItem.name ?? "Untitled")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(musicItem.composers ?? "Unknown Artist")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
            }
            .offset(y: 50)
        }
        .frame(height: 180)
        // Disc upar offset hai, isliye top space layout me include karte hain
        .padding(.top, 60)
    }
}
struct MusicRowView: View {
    let musicItem: MusicItem
    
    var body: some View {
        HStack(spacing: 16) {
            if let imagePath = musicItem.imagePath, !imagePath.isEmpty {
                CachedArtworkImage(imagePath: imagePath) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.linearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.linearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "music.note")
                        .font(.title2)
                        .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(musicItem.name ?? "Untitled")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(musicItem.composers ?? "Unknown Artist")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(16)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
