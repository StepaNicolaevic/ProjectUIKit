// UIFont+Extension.swift

import UIKit

/// Provides font with desired name
extension UIFont {
    /// Makes font with Verdana name and desired size
    /// - Parameter size: font's size
    /// - Returns: Verdana regular font with necessary size
    static func makeVerdanaRegular(size: CGFloat) -> UIFont? {
        .init(name: "Verdana", size: size) ?? .systemFont(ofSize: size)
    }

    /// Makes font with Verdana-bold name and desired size
    /// - Parameter size: font's size
    /// - Returns: Verdana bold font with necessary size
    static func makeVerdanaBold(size: CGFloat) -> UIFont? {
        .init(name: "Verdana-bold", size: size) ?? .boldSystemFont(ofSize: size)
    }
}
