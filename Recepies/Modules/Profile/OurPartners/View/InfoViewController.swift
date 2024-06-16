//
//  InfoViewController.swift
//  Recepies

import UIKit

final class InfoViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let cancelImage = "xmark"
        static let nameFontBold = "Verdana-Bold"
        static let nameFont = "Verdana"
        static let nameForDiscount = "Your discount -30%\n\nPromocode RECIPE30"
    }

    // MARK: - Visual Components

    let nameRestoraneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.nameFontBold, size: 20)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let adressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.nameFont, size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let discountLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.nameForDiscount
        label.font = UIFont(name: Constants.nameFont, size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.cancelImage), for: .normal)
        button.tintColor = .black
        button.sizeToFit()
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Public Properties

    var adressInfo: DataAdress? {
        didSet {
            nameRestoraneLabel.text = adressInfo?.title
            adressLabel.text = adressInfo?.address
        }
    }

    var setColorHandler: VoidHandler?

    // MARK: - Initialize

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setColorHandler?()
    }

    // MARK: - Private methods

    private func configureUI() {
        view.addSubview(cancelButton)
        view.addSubview(nameRestoraneLabel)
        view.addSubview(adressLabel)
        view.addSubview(discountLabel)
        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26),

            nameRestoraneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameRestoraneLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 53),
            nameRestoraneLabel.widthAnchor.constraint(equalToConstant: 350),
            nameRestoraneLabel.heightAnchor.constraint(equalToConstant: 24),

            adressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adressLabel.topAnchor.constraint(equalTo: nameRestoraneLabel.bottomAnchor, constant: 8),
            adressLabel.widthAnchor.constraint(equalToConstant: 350),
            adressLabel.heightAnchor.constraint(equalToConstant: 24),

            discountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            discountLabel.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 43),
            discountLabel.widthAnchor.constraint(equalToConstant: 350),
            discountLabel.heightAnchor.constraint(equalToConstant: 80),
        ])
    }

    @objc private func dismissScreen() {
        dismiss(animated: true)
    }
}
