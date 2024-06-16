// UIColor+Extension.swift

import UIKit

/// To implement Lightwight pattern
extension UIColor {
    /// Storage for already initiate colors in app
    static var colorStorageMap: [String: UIColor] = [:]
    /// Returns UIColor instance by creating new one or by getting from ColorStorageMap if already existed
    /// - Parameters:
    ///  red: red component of color
    ///  green: green component of color
    ///  blue: blue component of color
    ///  alpha: alpha component of color
    /// - Returns: UIColor instance by given color components
    static func makeColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        let key = "\(red)\(green)\(blue)\(alpha)"
        if let color = colorStorageMap[key] {
            return color
        }
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        colorStorageMap[key] = color
        return color
    }
}
