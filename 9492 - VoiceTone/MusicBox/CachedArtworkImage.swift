import SwiftUI
import UIKit

enum MusicFileStore {
    static let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    static func url(forRelativePath path: String) -> URL {
        documentsDirectory.appendingPathComponent(path)
    }
}

@MainActor
final class CachedArtworkLoader: ObservableObject {
    @Published private(set) var image: UIImage?

    private let imagePath: String
    private var loadTask: Task<Void, Never>?

    private static let imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        return cache
    }()

    init(imagePath: String) {
        self.imagePath = imagePath
    }

    deinit {
        loadTask?.cancel()
    }

    func loadIfNeeded() {
        guard image == nil else { return }

        let cacheKey = imagePath as NSString
        if let cached = Self.imageCache.object(forKey: cacheKey) {
            image = cached
            return
        }

        loadTask?.cancel()
        loadTask = Task { [imagePath] in
            let loadedImage = await Task.detached(priority: .userInitiated) {
                UIImage(contentsOfFile: MusicFileStore.url(forRelativePath: imagePath).path)
            }.value

            guard !Task.isCancelled else { return }
            if let loadedImage {
                Self.imageCache.setObject(loadedImage, forKey: cacheKey)
                image = loadedImage
            }
        }
    }
}

struct CachedArtworkImage<Placeholder: View>: View {
    private let placeholder: Placeholder
    @StateObject private var loader: CachedArtworkLoader

    init(imagePath: String, @ViewBuilder placeholder: () -> Placeholder) {
        _loader = StateObject(wrappedValue: CachedArtworkLoader(imagePath: imagePath))
        self.placeholder = placeholder()
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .task {
            loader.loadIfNeeded()
        }
    }
}
