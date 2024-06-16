// TitleTableViewCell.swift

import UIKit

/// Title box with general information about the recipe
final class TitleTableViewCell: UITableViewCell {
    // MARK: - Constants

    static let reuseID = String(describing: TitleTableViewCell.self)

    // MARK: - Visual Components

    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
//        imageView.image = .fish1
        return imageView
    }()

    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "1"
        label.font = .makeVerdanaBold(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let weightView: UIView = {
        let view = UIView()
        view.backgroundColor = .currentBlue.withAlphaComponent(0.6)
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconWeightImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .pot
        return imageView
    }()

    private let textWeightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .makeVerdanaRegular(size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cooKingTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = .currentBlue.withAlphaComponent(0.6)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconCooKingTimeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .timerCook
        imageView.tintColor = .white
        return imageView
    }()

    private let textCooKingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .makeVerdanaRegular(size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
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

    func setupView(recipe: RecipeDetail) {
        recipeNameLabel.text = recipe.name
        textWeightLabel.text = "\(Int(recipe.calories)) g"
        textCooKingTimeLabel.text = "Cooking time \(Int(recipe.timeToCook)) min"

        let networkService = NetworkService(requestCreator: RequestCreator())
        let proxyService = Proxy(service: networkService)
        proxyService.loadImage(by: recipe.recipeImage) { result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    // MARK: - Private Methods

    private func configureView() {
        selectionStyle = .none
        weightView.addSubview(iconWeightImage)
        weightView.addSubview(textWeightLabel)
        recipeImageView.addSubview(weightView)
        cooKingTimeView.addSubview(iconCooKingTimeImage)
        cooKingTimeView.addSubview(textCooKingTimeLabel)
        recipeImageView.addSubview(cooKingTimeView)
        contentView.addSubview(recipeNameLabel)
        contentView.addSubview(recipeImageView)
        addConstraintCell()
    }

    private func addConstraintCell() {
        setNameRecipeLabelConstraint()
        configureRecipeImage()
        setWeightViewConstraint()
        setIconWeightImageConstraint()
        setTextWeightLabelConstraint()
        setCooKingTimeViewConstraint()
        setIconCooKingTimeImageConstraint()
        setTextCooKingTimeLabelConstraint()
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
            recipeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }

    private func setWeightViewConstraint() {
        NSLayoutConstraint.activate([
            weightView.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 8),
            weightView.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -8),
            weightView.widthAnchor.constraint(equalToConstant: 50),
            weightView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setIconWeightImageConstraint() {
        NSLayoutConstraint.activate([
            iconWeightImage.topAnchor.constraint(equalTo: weightView.topAnchor, constant: 11),
            iconWeightImage.centerXAnchor.constraint(equalTo: weightView.centerXAnchor),
            iconWeightImage.widthAnchor.constraint(equalToConstant: 20),
            iconWeightImage.heightAnchor.constraint(equalToConstant: 15),
        ])
    }

    private func setTextWeightLabelConstraint() {
        NSLayoutConstraint.activate([
            textWeightLabel.topAnchor.constraint(equalTo: iconWeightImage.bottomAnchor, constant: 4),
            textWeightLabel.centerXAnchor.constraint(equalTo: weightView.centerXAnchor),
        ])
    }

    private func setCooKingTimeViewConstraint() {
        NSLayoutConstraint.activate([
            cooKingTimeView.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            cooKingTimeView.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor),
            cooKingTimeView.widthAnchor.constraint(equalToConstant: 125),
            cooKingTimeView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setIconCooKingTimeImageConstraint() {
        NSLayoutConstraint.activate([
            iconCooKingTimeImage.leadingAnchor.constraint(equalTo: cooKingTimeView.leadingAnchor, constant: 11),
            iconCooKingTimeImage.centerYAnchor.constraint(equalTo: cooKingTimeView.centerYAnchor),
            iconCooKingTimeImage.widthAnchor.constraint(equalToConstant: 20),
            iconCooKingTimeImage.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func setTextCooKingTimeLabelConstraint() {
        NSLayoutConstraint.activate([
            textCooKingTimeLabel.topAnchor.constraint(equalTo: cooKingTimeView.topAnchor, constant: 10),
            textCooKingTimeLabel.leadingAnchor.constraint(equalTo: iconCooKingTimeImage.trailingAnchor, constant: 5),
            textCooKingTimeLabel.widthAnchor.constraint(equalToConstant: 83),
            textCooKingTimeLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
