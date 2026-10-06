import SwiftUI

enum AppTheme {
    static let accentColor = UIColor(red: 0.24, green: 0.49, blue: 0.98, alpha: 1.0)
    static let navBackgroundColor = UIColor(red: 0.08, green: 0.11, blue: 0.19, alpha: 1.0)
    static let tabBackgroundColor = UIColor(red: 0.10, green: 0.13, blue: 0.20, alpha: 1.0)
    static let appBackgroundColor = UIColor(red: 0.05, green: 0.07, blue: 0.12, alpha: 1.0)
    static let surfaceColor = UIColor(red: 0.12, green: 0.15, blue: 0.22, alpha: 1.0)
    static let elevatedSurfaceColor = UIColor(red: 0.16, green: 0.19, blue: 0.27, alpha: 1.0)

    static var appBackground: Color { Color(uiColor: appBackgroundColor) }
    static var surface: Color { Color(uiColor: surfaceColor) }
    static var elevatedSurface: Color { Color(uiColor: elevatedSurfaceColor) }

    static func configureAppearance() {
        configureNavigationBar()
        configureTabBar()
    }

    private static func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navBackgroundColor
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.15)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 33, weight: .bold)
        ]

        let backImage = UIImage(systemName: "chevron.left.circle.fill")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffset(horizontal: -300, vertical: 0),
            for: .default
        )
    }

    private static func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = tabBackgroundColor
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.15)

        let normalItemAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.70),
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        let selectedItemAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: accentColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]

        let itemAppearance = appearance.stackedLayoutAppearance
        itemAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.70)
        itemAppearance.normal.titleTextAttributes = normalItemAttributes
        itemAppearance.selected.iconColor = accentColor
        itemAppearance.selected.titleTextAttributes = selectedItemAttributes

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = accentColor
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.70)
    }
}
