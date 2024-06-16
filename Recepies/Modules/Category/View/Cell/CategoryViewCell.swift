// CategoryViewCell.swift

import UIKit

/// Cell to show short information for recipe
final class CategoryViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let timerLabelText = " min"
        static let caloriesLabelText = " kkal"
    }

    static let reuseID = String(describing: CategoryViewCell.self)

    // MARK: - Visual Components

    private let dishImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Simple fish and corn"
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .makeVerdanaRegular(size: 14)
        return label
    }()

    private let grayBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .cellBackground
        return view
    }()

    private lazy var timerImageView = makeSmallImageView(image: .timer)
    private lazy var pizzaImageView = makeSmallImageView(image: .pizza)

    private lazy var timerLabel = makeBottomLabel(title: "60\(Constants.timerLabelText)")
    private lazy var caloriesLabel = makeBottomLabel(title: "274\(Constants.caloriesLabelText)")

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: .chevronRight)
        imageView.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return imageView
    }()

    // MARK: - Private Properties

    private var recipe: Recipe? {
        didSet {
            if let recipe {
                configureSubview(with: recipe)
            }
        }
    }

    private var viewsForShimmerEffect: [UIView] {
        grayBackgroundView.subviews
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

    func setupCell(with recipe: Recipe?) {
        self.recipe = recipe
    }

    func startCellShimmerAnimation() {
        viewsForShimmerEffect.forEach { $0.startShimmeringAnimation() }
    }

    func stopCellShimmerAnimation() {
        viewsForShimmerEffect.forEach { $0.stopShimmeringAnimation() }
    }

    // MARK: - Private Methods

    private func setupView() {
        chevronImageView.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        selectionStyle = .none
        contentView.addSubview(grayBackgroundView)
        contentView.disableTARMIC()
        grayBackgroundView.addSubviews(
            dishImageView,
            titleLabel,
            chevronImageView,
            timerImageView,
            timerLabel,
            pizzaImageView,
            caloriesLabel
        )
        grayBackgroundView.disableTARMIC()
        setupConstraints()
    }

    private func makeSmallImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }

    private func makeBottomLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .makeVerdanaRegular(size: 12)
        return label
    }

    private func configureSubview(with recipe: Recipe) {
        let networkService = NetworkService(requestCreator: RequestCreator())
        let proxyService = Proxy(service: networkService)
        proxyService.loadImage(by: recipe.recipeImage) { result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self.dishImageView.image = image
                }
            case let .failure(error):
                print(error)
            }
        }
        titleLabel.text = recipe.name
        timerLabel.text = "\(recipe.timeToCook)\(Constants.timerLabelText)"
        caloriesLabel.text = "\(recipe.calories)\(Constants.caloriesLabelText)"
    }
}

// MARK: - Constraints

private extension CategoryViewCell {
    func setupConstraints() {
        setupGrayBackgroundViewConstraints()
        setupDishImageViewConstraints()
        setupTitleLabelConstraints()
        setupChevronImageViewConstraints()
        setuptimerImageViewConstraints()
        setuptimerLabelConstraints()
        setupPizzaImageViewConstraints()
        setupCaloriesLabelConstraints()
    }

    func setupGrayBackgroundViewConstraints() {
        NSLayoutConstraint.activate([
            grayBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            grayBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            grayBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            grayBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
        ])
    }

    func setupDishImageViewConstraints() {
        NSLayoutConstraint.activate([
            dishImageView.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 10),
            dishImageView.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor, constant: 10),
            dishImageView.bottomAnchor.constraint(equalTo: grayBackgroundView.bottomAnchor, constant: -10),
            dishImageView.heightAnchor.constraint(equalToConstant: 80),
            dishImageView.widthAnchor.constraint(equalTo: dishImageView.heightAnchor),
        ])
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: dishImageView.topAnchor, constant: 12),
        ])
    }

    func setupChevronImageViewConstraints() {
        NSLayoutConstraint.activate([
            chevronImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 10),
            chevronImageView.centerYAnchor.constraint(equalTo: dishImageView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor),
            chevronImageView.heightAnchor.constraint(equalToConstant: 40),
            chevronImageView.widthAnchor.constraint(equalTo: chevronImageView.widthAnchor),
        ])
    }

    func setuptimerImageViewConstraints() {
        NSLayoutConstraint.activate([
            timerImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timerImageView.bottomAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: -13),
        ])
    }

    func setuptimerLabelConstraints() {
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: timerImageView.trailingAnchor, constant: 4),
            timerLabel.centerYAnchor.constraint(equalTo: timerImageView.centerYAnchor),
        ])
    }

    func setupPizzaImageViewConstraints() {
        NSLayoutConstraint.activate([
            pizzaImageView.leadingAnchor.constraint(equalTo: timerImageView.trailingAnchor, constant: 70),
            pizzaImageView.centerYAnchor.constraint(equalTo: timerImageView.centerYAnchor),
        ])
    }

    func setupCaloriesLabelConstraints() {
        NSLayoutConstraint.activate([
            caloriesLabel.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor, constant: 4),
            caloriesLabel.centerYAnchor.constraint(equalTo: timerImageView.centerYAnchor),
        ])
    }
}
