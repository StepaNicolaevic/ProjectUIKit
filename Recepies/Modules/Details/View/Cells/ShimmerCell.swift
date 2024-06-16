// ShimmerCell.swift

import UIKit

/// Cell Shimmer
final class ShimmerCell: UITableViewCell {
    // MARK: - Constants

    static let reuseID = String(describing: ShimmerCell.self)

    // MARK: - Visual Components

    private let recipeImageView: UIView = {
        let imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = " "
        label.font = .makeVerdanaBold(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let caloriesView = PFCView(title: "")
    private let carbohydratesView = PFCView(title: "")
    private let fatsView = PFCView(title: "")
    private let proteinsView = PFCView(title: "")

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [caloriesView, carbohydratesView, fatsView, proteinsView])
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let backGroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        recipeImageView.layer.cornerRadius = recipeImageView.bounds.height * 0.08
    }

    // MARK: - Public Methods

    func startShimer() {
        [
            recipeNameLabel,
            recipeImageView,
            backGroundView,
        ].forEach { $0.startShimmeringAnimation() }
        stackView.subviews.forEach { $0.startShimmeringAnimation() }
    }

    // MARK: - Private Methods

    private func configureView() {
        selectionStyle = .none
        contentView.addSubview(recipeNameLabel)
        contentView.addSubview(recipeImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(backGroundView)
        addConstraintCell()
    }

    private func addConstraintCell() {
        setNameRecipeLabelConstraint()
        configureRecipeImage()
        setupStackViewConstraints()
        setBackGroundViewConstraint()
    }

    private func setNameRecipeLabelConstraint() {
        NSLayoutConstraint.activate([
            recipeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recipeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }

    private func configureRecipeImage() {
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 20),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor),
        ])
    }

    func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            stackView.heightAnchor.constraint(equalToConstant: 53),
            stackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 20),
        ])
    }

    private func setBackGroundViewConstraint() {
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            backGroundView.heightAnchor.constraint(equalToConstant: 353),
            backGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
}
