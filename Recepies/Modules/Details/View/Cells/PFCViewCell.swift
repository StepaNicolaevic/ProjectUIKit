// PFCViewCell.swift

import UIKit

/// Cell to show PFC recipe information
final class PFCViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let gram = "g"
        static let sideInset = 45.0
    }

    static let reuseID = String(describing: PFCViewCell.self)

    // MARK: - Visual Components

    private let caloriesView = PFCView(title: Local.PFCView.Kkal.text)
    private let carbohydratesView = PFCView(title: Local.PFCView.Carbohydrates.text)
    private let fatsView = PFCView(title: Local.PFCView.Fats.text)
    private let proteinsView = PFCView(title: Local.PFCView.Proteins.text)

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [caloriesView, carbohydratesView, fatsView, proteinsView])
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Private Properties

    private var recipe: RecipeDetail? {
        didSet {
            if let recipe {
                configureSubview(with: recipe)
            }
        }
    }

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Public Methods

    func setupCell(with recipe: RecipeDetail?) {
        self.recipe = recipe
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.addSubview(stackView)
        contentView.disableTARMIC()
        setupConstraints()
        selectionStyle = .none
    }

    private func configureSubview(with recipe: RecipeDetail) {
        caloriesView.set(subtitle: "\(Int(recipe.calories))" + Local.PFCView.KCal.text)

        let carbohydratesAmount = makeFormattedString(from: recipe.carbohydrates)
        carbohydratesView.set(subtitle: carbohydratesAmount + Constants.gram)

        let fatsAmount = makeFormattedString(from: recipe.fats)
        fatsView.set(subtitle: fatsAmount + Constants.gram)

        let proteinsAmount = makeFormattedString(from: recipe.proteins)
        proteinsView.set(subtitle: proteinsAmount + Constants.gram)
    }

    private func makeFormattedString(from double: Double) -> String {
        String(format: "%0.2f", double)
    }
}

// MARK: - Constraints

private extension PFCViewCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.sideInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.sideInset),
            stackView.heightAnchor.constraint(equalToConstant: 53),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
}
