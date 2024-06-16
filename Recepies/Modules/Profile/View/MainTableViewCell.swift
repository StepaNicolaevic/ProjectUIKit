// MainTableViewCell.swift

import UIKit

/// Cell with avatar and username
final class MainTableViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constans {
        static let fullNameLabelFont = "Verdana-Bold"
        static let editNameButtonImage = "ipensela"
    }

    // MARK: - Visual Components

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 80
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constans.fullNameLabelFont, size: 25)
        label.textAlignment = .center
        return label
    }()

    private lazy var editNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constans.editNameButtonImage), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.addTarget(self, action: #selector(editLabel), for: .touchUpInside)
        return button
    }()

    // MARK: - Public Properties

    var editNameHandler: VoidHandler?
    var editAvatarHandler: VoidHandler?
    private let tapImageGesture = UITapGestureRecognizer()

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

    func setupCell(profile: User, data: Data) {
        avatarImageView.image = UIImage(data: data)
        fullNameLabel.text = profile.nickName
        avatarImageView.addGestureRecognizer(tapImageGesture)
        avatarImageView.isUserInteractionEnabled = true
        tapImageGesture.addTarget(self, action: #selector(editAvatar))
    }

    // MARK: - Private Methods

    private func addItemCell() {
        selectionStyle = .none
        contentView.addSubview(avatarImageView)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(editNameButton)
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 160),
            avatarImageView.widthAnchor.constraint(equalToConstant: 160),

            fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 36),
            fullNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 30),
            fullNameLabel.widthAnchor.constraint(equalToConstant: 256),
            fullNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            editNameButton.leadingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor, constant: 11),
            editNameButton.centerYAnchor.constraint(equalTo: fullNameLabel.centerYAnchor),
            editNameButton.heightAnchor.constraint(equalToConstant: 18),
            editNameButton.widthAnchor.constraint(equalToConstant: 18),

        ])
    }

    @objc private func editLabel() {
        editNameHandler?()
    }

    @objc private func editAvatar() {
        editAvatarHandler?()
    }
}
