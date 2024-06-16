// PFCView.swift

import UIKit

/// View to show PFC detailed information
final class PFCView: UIView {
    // MARK: - Constants

    private let heightRation = 31.0 / 53.0

    // MARK: - Visual Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .makeVerdanaRegular(size: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.text = title
        return label
    }()

    private lazy var topColoredView: UIView = {
        let view = UIView()
        view.backgroundColor = color
        return view
    }()

    private let bottomTransparentView = UIView()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .makeVerdanaRegular(size: 10)
        label.textColor = color
        label.textAlignment = .center
        label.text = subtitle
        return label
    }()

    // MARK: - Private Properties

    private var title: String
    private var subtitle: String
    private var color: UIColor = .currentBlue

    // MARK: - Initializers

    init(title: String = "", subtitle: String = "", color: UIColor = .currentBlue) {
        self.title = title
        self.subtitle = subtitle
        self.color = color
        super.init(frame: .zero)
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        title = "title"
        subtitle = "subtitle"
        color = .gray
        super.init(coder: coder)
    }

    // MARK: - Public Methods

    func set(subtitle: String) {
        self.subtitle = subtitle
        subtitleLabel.text = subtitle
    }

    // MARK: - Private Methods

    private func configureView() {
        layer.cornerRadius = 16
        layer.borderColor = color.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 16
        clipsToBounds = true
        addSubviews(topColoredView, bottomTransparentView, titleLabel, subtitleLabel)
        disableTARMIC()
        setupConstraints()
    }
}

// MARK: - Constraints

private extension PFCView {
    func setupConstraints() {
        setupTopColoredViewConstraints()
        setupBottomTransparentViewConstraints()
        setupTitleLabelConstraints()
        setupSubtitleLabelConstraints()
    }

    func setupTopColoredViewConstraints() {
        NSLayoutConstraint.activate([
            topColoredView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topColoredView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topColoredView.topAnchor.constraint(equalTo: topAnchor),
            topColoredView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightRation),
        ])
    }

    func setupBottomTransparentViewConstraints() {
        NSLayoutConstraint.activate([
            bottomTransparentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomTransparentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomTransparentView.topAnchor.constraint(equalTo: topColoredView.bottomAnchor),
            bottomTransparentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: topColoredView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: topColoredView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: topColoredView.trailingAnchor),
        ])
    }

    func setupSubtitleLabelConstraints() {
        NSLayoutConstraint.activate([
            subtitleLabel.centerYAnchor.constraint(equalTo: bottomTransparentView.centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: bottomTransparentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: bottomTransparentView.trailingAnchor),
        ])
    }
}
