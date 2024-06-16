// SortingButton.swift

import UIKit

/// Button for search sorting criterias with 3 states
final class SortingButton: UIButton {
    // MARK: - Types

    /// Enum to determinate button appearance depending of state
    enum SortingType {
        /// Initial state, no sorting
        case none
        /// Sorting from less to more
        case lessToMore
        /// Sorting from more to less
        case moreToLess
    }

    var sortingState: SortingType = .none {
        didSet {
            updateAppearance(with: sortingState)
        }
    }

    // MARK: - Private Properties

    private let title: String
    private let height: CGFloat

    // MARK: - Initializers

    init(title: String, height: CGFloat) {
        self.title = title
        self.height = height
        super.init(frame: .zero)
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        height = 0
        title = ""
        super.init(coder: coder)
    }

    // MARK: - Public Methods

    func getSortingPredicate() -> SortingHandler? {
        let sortingHandler: SortingHandler?
        switch sortingState {
        case .none:
            sortingHandler = nil
        case .lessToMore:
            sortingHandler = { lhs, rhs in
                lhs < rhs
            }
        case .moreToLess:
            sortingHandler = { lhs, rhs in
                lhs > rhs
            }
        }
        return sortingHandler
    }

    // MARK: - Private Methods

    private func configureView() {
        updateAppearance(with: sortingState)
        setTitle("    \(title)   ", for: .normal)
        heightAnchor.constraint(equalToConstant: height).isActive = true
        layer.cornerRadius = height / 2
        addTarget(self, action: #selector(updateState), for: .touchUpInside)
        semanticContentAttribute = .forceRightToLeft
        titleLabel?.font = UIFont.makeVerdanaRegular(size: 16)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 12)
    }

    private func updateAppearance(with sortingState: SortingType) {
        switch sortingState {
        case .none:
            backgroundColor = .cellBackground
            setTitleColor(.black, for: .normal)
            tintColor = .black
            setImage(.upBlack, for: .normal)
        case .lessToMore:
            backgroundColor = .currentBlue
            setTitleColor(.white, for: .normal)
            tintColor = .white
            setImage(.upWhite.withRenderingMode(.alwaysOriginal), for: .normal)
        case .moreToLess:
            backgroundColor = .currentBlue
            setTitleColor(.white, for: .normal)
            tintColor = .white
            setImage(.down.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    @objc private func updateState() {
        switch sortingState {
        case .none:
            sortingState = .lessToMore
        case .lessToMore:
            sortingState = .moreToLess
        case .moreToLess:
            sortingState = .none
        }
    }
}
