// ErrorView.swift

import UIKit

/// Error view
final class ErrorView: UIView {
    // MARK: - Constants

    private enum Constants {
        static let refreshText = "  Reload"
    }

    // MARK: - Vizual components

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(grayView)
        stack.addArrangedSubview(nothingLabel)
        stack.addArrangedSubview(refreshButton)
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 17
        return stack
    }()

    private let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = .searchBackground
        view.layer.cornerRadius = 12
        return view
    }()

    private let iconImageView = UIImageView()

    private let nothingLabel: UILabel = {
        let label = UILabel()
        label.font = .makeVerdanaRegular(size: 14)
        label.textAlignment = .center
        return label
    }()

    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.refreshText, for: .normal)
        button.backgroundColor = .searchBackground
        button.semanticContentAttribute = .forceLeftToRight
        button.titleLabel?.font = .makeVerdanaRegular(size: 14)
        button.setTitleColor(.gray, for: .normal)
        button.setImage(.refresh, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initialization

    convenience init(state: CategoryState, action: Selector, view: UIViewController?) {
        self.init()
        setupView(action: action, view: view)
        updateState(state)
    }

    // MARK: - Public Methods

    func updateState(_ state: CategoryState) {
        switch state {
        case .noData:
            refreshButton.isHidden = true
            iconImageView.image = .search
            nothingLabel.text = "Start typing text"
        default:
            refreshButton.isHidden = false
            refreshButton.isUserInteractionEnabled = true
            iconImageView.image = .lightning
            nothingLabel.text = "Failed to load data"
        }
    }

    // MARK: - Private Methods

    private func setupView(action: Selector, view: UIViewController?) {
        backgroundColor = .systemBackground
        refreshButton.addTarget(view, action: action, for: .touchUpInside)
        addSubview(stackView)
        disableTARMIC()
        grayView.addSubview(iconImageView)
        grayView.disableTARMIC()
        setupConstraints()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        setupStackViewConstraints()
        setupGrayViewConstraints()
        setupFavoriteImageViewConstraints()
    }

    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            refreshButton.heightAnchor.constraint(equalToConstant: 32),
            refreshButton.widthAnchor.constraint(equalToConstant: 150),
        ])
    }

    private func setupGrayViewConstraints() {
        NSLayoutConstraint.activate([
            grayView.heightAnchor.constraint(equalToConstant: 50),
            grayView.widthAnchor.constraint(equalTo: grayView.heightAnchor),
        ])
    }

    private func setupFavoriteImageViewConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: grayView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: grayView.centerYAnchor),
        ])
    }
}
