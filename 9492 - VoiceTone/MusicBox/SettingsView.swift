import SwiftUI
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("autoSaveRecordings") private var autoSaveRecordings = true
    @AppStorage("audioQuality") private var audioQuality = "High"
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Help Section
                Section {
                    NavigationLink(destination: HowToUseView()) {
                        Label("How to Use", systemImage: "questionmark.circle.fill")
                            .foregroundColor(Color(uiColor: AppTheme.accentColor))
                    }
                } header: {
                    Text("Help")
                }
                .listRowBackground(AppTheme.surface)
                
                // Recording Settings
                Section {
                    Picker("Audio Quality", selection: $audioQuality) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    
                    Toggle(isOn: $autoSaveRecordings) {
                        Label("Auto-Save Recordings", systemImage: "arrow.down.circle.fill")
                    }
                    .tint(Color(uiColor: AppTheme.accentColor))
                } header: {
                    Text("Recording")
                } footer: {
                    Text("Higher quality uses more storage space")
                }
                .listRowBackground(AppTheme.surface)
                
                // Notifications
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Enable Notifications", systemImage: "bell.fill")
                    }
                    .tint(Color(uiColor: AppTheme.accentColor))
                } header: {
                    Text("Notifications")
                }
                .listRowBackground(AppTheme.surface)
                
                // Appearance
//                Section {
//                    Label("Dark Theme Enabled", systemImage: "moon.fill")
//                        .foregroundColor(.secondary)
//                } header: {
//                    Text("Appearance")
//                }
//                .listRowBackground(AppTheme.surface)
                
                // Storage
                Section {
                    Button(action: { showDeleteAlert = true }) {
                        Label("Clear All Recordings", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("Storage")
                } footer: {
                    Text("This will permanently delete all your recordings")
                }
                .listRowBackground(AppTheme.surface)
                
                // About
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("My Music Team")
                            .foregroundColor(.secondary)
                    }
                    
//                    NavigationLink(destination: LegalDocumentView(documentType: .privacyPolicy)) {
//                        HStack {
//                            Text("Privacy Policy")
//                            Spacer()
//                            Image(systemName: "arrow.up.right.square")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
                    
//                    NavigationLink(destination: LegalDocumentView(documentType: .termsOfService)) {
//                        HStack {
//                            Text("Terms of Service")
//                            Spacer()
//                            Image(systemName: "arrow.up.right.square")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
                } header: {
                    Text("About")
                }
                .listRowBackground(AppTheme.surface)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(AppTheme.appBackground)
            .tint(Color(uiColor: AppTheme.accentColor))
            .navigationTitle("Settings")
            .alert("Delete All Recordings?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    clearAllRecordings()
                }
            } message: {
                Text("This action cannot be undone. All your recordings will be permanently deleted.")
            }
        }
    }

    private func clearAllRecordings() {
        let fetchRequest: NSFetchRequest<MusicItem> = MusicItem.fetchRequest()
        guard let items = try? viewContext.fetch(fetchRequest) else { return }

        for item in items {
            if let audioPath = item.audioPath {
                deleteFileIfExists(relativePath: audioPath)
            }
            if let imagePath = item.imagePath {
                deleteFileIfExists(relativePath: imagePath)
            }
            viewContext.delete(item)
        }

        try? viewContext.save()
    }

    private func deleteFileIfExists(relativePath: String) {
        let fileURL = MusicFileStore.url(forRelativePath: relativePath)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
}
