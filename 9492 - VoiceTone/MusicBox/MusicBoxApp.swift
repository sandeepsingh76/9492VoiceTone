import SwiftUI
import Firebase

@main
struct MusicBoxApp: App {
    
    init() {
        sFC()
        AppTheme.configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            Z9()
//            MainTabView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .preferredColorScheme(.dark)
        }
    }
    func sFC() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}
