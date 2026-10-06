import SwiftUI

enum LegalDocumentType {
    case privacyPolicy
    case termsOfService

    var title: String {
        switch self {
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsOfService:
            return "Terms of Service"
        }
    }

    var content: String {
        switch self {
        case .privacyPolicy:
            return """
MusicBox Privacy Policy

Effective Date: March 2, 2026

MusicBox records and stores your audio files on your device so you can play and manage your music recordings.

Data We Access
- Microphone access is used only when you choose to record audio.
- Photo Library access is used only when you choose cover artwork from your gallery.

Data Storage
- Your recordings and cover images are stored locally on your device.
- MusicBox does not require account creation.
- MusicBox does not upload your recordings to external servers.

Contact
If you need support for privacy questions, contact the app publisher from the App Store support page.
"""
        case .termsOfService:
            return """
MusicBox Terms of Service

Effective Date: March 2, 2026

By using MusicBox, you agree to use the app only for lawful recording and playback purposes.

Usage Terms
- You are responsible for any content you record or store in the app.
- Do not use the app to violate intellectual property or local laws.
- You may delete your recordings at any time from within the app.

Disclaimer
MusicBox is provided as-is without warranties. Availability and features may be updated over time.

Contact
For support requests, use the app support contact listed in the App Store.
"""
        }
    }
}

struct LegalDocumentView: View {
    let documentType: LegalDocumentType

    var body: some View {
        ScrollView {
            Text(documentType.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
        }
        .background(AppTheme.appBackground.ignoresSafeArea())
        .navigationTitle(documentType.title)
        .navigationBarTitleDisplayMode(.inline)
        .musicBoxCustomBackButton()
    }
}
