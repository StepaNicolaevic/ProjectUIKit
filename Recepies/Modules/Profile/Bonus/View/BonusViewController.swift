// BonusViewController.swift

import UIKit

/// Screen with number of shoes
final class BonusViewController: UIViewController {
    // MARK: - Constants

    private enum Constans {
        static let veradanaBoldFont = "Verdana-Bold"
        static let cancelButtonImage = "xmark"
        static let bonuslabelText = "Your bonuses"
        static let countBonusLabelText = "100"
    }

    // MARK: - Visual Components

    private let bonusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constans.veradanaBoldFont, size: 20)
        label.text = Constans.bonuslabelText
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()

    private let countBonusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constans.veradanaBoldFont, size: 30)
        label.textAlignment = .left
        label.text = Constans.countBonusLabelText
        label.textColor = .darkGray
        return label
    }()

    private let boxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .box
        return imageView
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .starYellow
        return imageView
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constans.cancelButtonImage), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        button.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        return button
    }()

    // MARK: - Public Properties

    var bonusPresenter: BonusPresenter?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(bonusLabel)
        view.addSubview(boxImageView)
        view.addSubview(countBonusLabel)
        view.addSubview(starImageView)
        view.addSubview(cancelButton)
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            bonusLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            bonusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bonusLabel.heightAnchor.constraint(equalToConstant: 24),
            bonusLabel.widthAnchor.constraint(equalToConstant: 350),

            boxImageView.topAnchor.constraint(equalTo: bonusLabel.bottomAnchor, constant: 13),
            boxImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boxImageView.heightAnchor.constraint(equalToConstant: 136),
            boxImageView.widthAnchor.constraint(equalToConstant: 150),

            starImageView.topAnchor.constraint(equalTo: boxImageView.bottomAnchor, constant: 32),
            starImageView.leadingAnchor.constraint(equalTo: boxImageView.leadingAnchor, constant: 24),
            starImageView.heightAnchor.constraint(equalToConstant: 29),
            starImageView.widthAnchor.constraint(equalToConstant: 29),

            countBonusLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 13),
            countBonusLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            countBonusLabel.heightAnchor.constraint(equalToConstant: 35),
            countBonusLabel.widthAnchor.constraint(equalToConstant: 177),

            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),

        ])
    }

    @objc private func tapCancel() {
        bonusPresenter?.dismisView()
    }
}

// MARK: - BonusViewController + BonusViewProtocol

extension BonusViewController: BonusViewProtocol {
    func closeView() {
        dismiss(animated: true)
    }
}
