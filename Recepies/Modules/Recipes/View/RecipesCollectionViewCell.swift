// RecipesCollectionViewCell.swift


import UIKit

/// Category cel
final class RecipesCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        static let veradanaFont = "Verdana"
    }

    // MARK: - Visual Components

    private let categoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: Constants.veradanaFont, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .grayAlfa
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Public Properties

    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderWidth = 2
                contentView.layer.borderColor = UIColor.currentBlue.cgColor
                view.backgroundColor = .currentBlue.withAlphaComponent(0.82)
            } else {
                contentView.layer.borderWidth = 0
                view.backgroundColor = .grayAlfa
            }
        }
    }

    // MARK: - Public Methods

    func setupCell(category: Category) {
        categoryImage.image = UIImage(named: category.categoryImage)
        nameLabel.text = category.name
        configureCell()
        setCostraints()
        heightSettingInViewConstraint()
    }

    // MARK: - Private Methods

    private func configureCell() {
        categoryImage.addSubview(view)
        contentView.addSubview(categoryImage)
        contentView.addSubview(nameLabel)
        contentView.layer.cornerRadius = contentView.bounds.width / 10
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.masksToBounds = true
        contentView.layer.cornerCurve = .continuous
        setImageCostraints()
        settingTheShadow()
    }

    private func settingTheShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }

    private func setImageCostraints() {
        NSLayoutConstraint.activate([
            categoryImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    private func setCostraints() {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

        ])
    }

    private func heightSettingInViewConstraint() {
        switch contentView.bounds.height {
        case 0 ... 150:
            view.heightAnchor.constraint(equalToConstant: contentView.bounds.height / 4).isActive = true
            nameLabel.font = UIFont(name: Constants.veradanaFont, size: 16)
        case 151 ... 200:
            view.heightAnchor.constraint(equalToConstant: contentView.bounds.height / 6).isActive = true
        default:
            view.heightAnchor.constraint(equalToConstant: contentView.bounds.height / 5).isActive = true
        }
    }
}
