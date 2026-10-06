import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 13, weight: .bold))
                            Text("Back")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 12)
                        .background(Color.white.opacity(0.14), in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.24), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
    }
}

extension View {
    func musicBoxCustomBackButton() -> some View {
        modifier(CustomBackButtonModifier())
    }
}
