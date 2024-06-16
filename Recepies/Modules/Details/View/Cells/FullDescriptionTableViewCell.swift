// FullDescriptionTableViewCell.swift

import UIKit

/// Recipe detail box
final class FullDescriptionTableViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let veradanaFont = "Verdana"
    }

    static let reuseID = String(describing: FullDescriptionTableViewCell.self)

    // MARK: - Visual Components

    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: Constants.veradanaFont, size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let backGroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.gradientBackground.cgColor, UIColor.white.cgColor]
        return gradientLayer
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    // MARK: - Life Cycle

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = backGroundView.bounds
    }

    // MARK: - Public Methods

    func setupCell(recipe: RecipeDetail) {
        recipeNameLabel.text = recipe.description
    }

    // MARK: - Private Methods

    private func configureView() {
        backGroundView.layer.addSublayer(gradientLayer)
        contentView.addSubview(backGroundView)
        contentView.addSubview(recipeNameLabel)
        setConstraints()
        selectionStyle = .none
    }

    private func setConstraints() {
        setNameRecipeLabelConstraint()
        setBackGroundViewConstraint()
    }

    private func setNameRecipeLabelConstraint() {
        NSLayoutConstraint.activate([
            recipeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            recipeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -27),
            recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 27),
            recipeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27),
        ])
    }

    private func setBackGroundViewConstraint() {
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo: recipeNameLabel.topAnchor, constant: -27),
            backGroundView.bottomAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 27),
            backGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
