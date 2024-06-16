// UIView+Extension.swift

import UIKit

/// Adding useful functions to UIVIew
extension UIView {
    /// Function to add several subviews separated by comma
    ///  - Parameter subviews: all the subviews added to general view
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { self.addSubview($0) }
    }

    /// Disable translatesAutoresizingMaskIntoConstraints for all subviews
    func disableTARMIC() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    /// Add shimmer effect to view
    func startShimmeringAnimation() {
        // Base parameters
        let lightColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5).cgColor
        let blackColor = UIColor.black.cgColor
        let animationSpeed = 1.0

        let gradientLayer = makeGradientLayer()
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        layer.mask = gradientLayer

        addGrayShimmerLayer()

        CATransaction.begin()
        let animation = makeAnimation(animationSpeed: animationSpeed)
        gradientLayer.add(animation, forKey: "")
        CATransaction.commit()
    }

    /// Remove shimmer effect from view
    func stopShimmeringAnimation() {
        layer.mask = nil
        layer.sublayers?.first?.removeFromSuperlayer()
    }

    /// Making gradien layer for shimmer effect
    private func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(
            x: -bounds.size.width,
            y: -bounds.size.height,
            width: 3 * bounds.size.width,
            height: 3 * bounds.size.height
        )
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.35, 0.50, 0.65]
        return gradientLayer
    }

    /// Adds gray color layer to top of view
    private func addGrayShimmerLayer() {
        let maxPossibleRadius = 12.0
        let minHeightForDynamicRadius = 60.0
        let usefullDevider = 5.0
        let grayShimmerLayer = CALayer()
        grayShimmerLayer.backgroundColor = UIColor.systemGray4.cgColor
        grayShimmerLayer.frame = bounds
        let radius = grayShimmerLayer.frame.height > minHeightForDynamicRadius ? maxPossibleRadius : grayShimmerLayer
            .frame.height / usefullDevider
        grayShimmerLayer.cornerRadius = radius
        grayShimmerLayer.masksToBounds = true
        layer.addSublayer(grayShimmerLayer)
    }

    /// Makes animation with desired parameters
    ///  - Parameter animationSpeed: time interval for animation repeating
    ///  - Returns: Basic animation instance
    private func makeAnimation(animationSpeed: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = .infinity
        return animation
    }
}
