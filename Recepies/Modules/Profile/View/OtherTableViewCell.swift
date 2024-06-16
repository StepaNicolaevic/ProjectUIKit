// OtherTableViewCell.swift


import UIKit

/// Cell with additional features
final class OtherTableViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constans {
        static let currentLabelFont = "Verdana"
        static let editNameButtonImage = "ipensela"
    }

    // MARK: - Visual Components

    private let currentOptionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constans.currentLabelFont, size: 18)
        label.textAlignment = .left
        label.textColor = .darkGray
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .backIcon
        return view
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addItemCell()
        setConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addItemCell()
        setConstraint()
    }

    // MARK: - Public Methods

    func setupCell(options: OptionsProtocol) {
        iconImageView.image = UIImage(named: options.icon)
        currentOptionsLabel.text = options.nameOptions
    }

    // MARK: - Private Methods

    private func addItemCell() {
        contentView.addSubview(backView)
        contentView.addSubview(currentOptionsLabel)
        contentView.addSubview(iconImageView)
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backView.heightAnchor.constraint(equalToConstant: 48),
            backView.widthAnchor.constraint(equalToConstant: 48),

            currentOptionsLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            currentOptionsLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            currentOptionsLabel.heightAnchor.constraint(equalToConstant: 24),
            currentOptionsLabel.widthAnchor.constraint(equalToConstant: 224),

            iconImageView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 23),
            iconImageView.widthAnchor.constraint(equalToConstant: 23),

        ])
    }
}
