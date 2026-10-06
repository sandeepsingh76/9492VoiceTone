import SwiftUI
import PhotosUI

struct MusicDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let audioURL: URL
    
    @State private var musicName = ""
    @State private var composers = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, composers
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [AppTheme.appBackground, AppTheme.surface],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        imageSection
                        
                        detailsSection
                        
                        saveButton
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Add Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                        .foregroundColor(Color(uiColor: AppTheme.accentColor))
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private var imageSection: some View {
        VStack(spacing: 16) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.linearGradient(
                            colors: [.blue.opacity(0.2), .purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 200, height: 200)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 50))
                            .foregroundStyle(.linearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                        
                        Text("Add Cover Art")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                }
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            }
            
            Button(action: { showImagePicker = true }) {
                HStack(spacing: 8) {
                    Image(systemName: selectedImage == nil ? "plus.circle.fill" : "arrow.triangle.2.circlepath")
                        .font(.headline)
                    Text(selectedImage == nil ? "Select Image" : "Change Image")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
            }
        }
    }
    
    private var detailsSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Music Name")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.secondary)
                
                TextField("Enter music name", text: $musicName)
                    .focused($focusedField, equals: .name)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Composers")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.secondary)
                
                TextField("Enter composer names", text: $composers)
                    .focused($focusedField, equals: .composers)
                    .textFieldStyle(CustomTextFieldStyle())
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveMusic) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.headline)
                Text("Save Music")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                musicName.isEmpty ?
                LinearGradient(colors: [.gray, .gray], startPoint: .leading, endPoint: .trailing) :
                LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: musicName.isEmpty ? .clear : .green.opacity(0.3), radius: 15, x: 0, y: 8)
        }
        .disabled(musicName.isEmpty)
        .padding(.top, 8)
    }
    
    private func saveMusic() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let audioFileName = UUID().uuidString + ".m4a"
        let audioDestination = documentsPath.appendingPathComponent(audioFileName)
        try? FileManager.default.copyItem(at: audioURL, to: audioDestination)
        
        var imagePath: String?
        if let image = selectedImage {
            let imageFileName = UUID().uuidString + ".jpg"
            let imageDestination = documentsPath.appendingPathComponent(imageFileName)
            if let data = image.jpegData(compressionQuality: 0.8) {
                try? data.write(to: imageDestination)
                imagePath = imageFileName
            }
        }
        
        let newItem = MusicItem(context: viewContext)
        newItem.id = UUID()
        newItem.name = musicName
        newItem.composers = composers.isEmpty ? "Unknown Artist" : composers
        newItem.imagePath = imagePath
        newItem.audioPath = audioFileName
        newItem.createdAt = Date()
        
        try? viewContext.save()
        dismiss()
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(AppTheme.elevatedSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .foregroundColor(.white)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}
