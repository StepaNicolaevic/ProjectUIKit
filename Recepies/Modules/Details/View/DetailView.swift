// DetailView.swift

import UIKit

/// Protocol for detail screen
protocol DetailViewProtocol: AnyObject {
    /// Change button state
    func updateFavoriteButton()
    /// Reload table view
    func reloadData()
    /// Current state
    var state: CategoryState { get set }
}

/// Screen with detailed information for recipe
final class DetailView: UIViewController {
    // MARK: - Types

    /// Cell types
    enum CellTypesDetail {
        /// Cell with title and picture
        case title
        /// Cell with characteristics
        case characteristics
        /// Box with a full description of the recipe
        case fullDescription
    }

    // MARK: - Visual Components

    private let tableView = UITableView()

    private let favoritesButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshControlPulled(sender:)), for: .valueChanged)
        return control
    }()

    private lazy var errorView = ErrorView(state: .data, action: #selector(refreshButtonAction), view: self)

    // MARK: - Public Properties

    var presenter: DetailPresenter?

    var state: CategoryState = .loading {
        didSet {
            updateView(state: state)
        }
    }

    // MARK: - Private Properties

    private let cellTypes: [CellTypesDetail] = [.title, .characteristics, .fullDescription]

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftNavigationItem()
        setRightNavigationItem()
        configureTableView()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.fetchData()
    }

    // MARK: - Private Methods

    private func updateView(state: CategoryState) {
        switch state {
        case .noData:
            errorView.updateState(state)
            errorView.isHidden = false
        case let .error(error):
            errorView.updateState(state)
            errorView.isHidden = false
        default:
            errorView.isHidden = true
        }
        tableView.reloadData()
    }

    private func configureView() {
        view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.isHidden = true
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setLeftNavigationItem() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }

    private func setRightNavigationItem() {
        updateFavoriteButton()
        favoritesButton.addTarget(self, action: #selector(addFavoritesRecipe), for: .touchUpInside)

        let shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        shareButton.setImage(.send, for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)

        let rightBarView = UIView()
        rightBarView.addSubviews(shareButton, favoritesButton)
        rightBarView.disableTARMIC()

        NSLayoutConstraint.activate([
            favoritesButton.trailingAnchor.constraint(equalTo: rightBarView.trailingAnchor),
            favoritesButton.centerYAnchor.constraint(equalTo: rightBarView.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: favoritesButton.leadingAnchor, constant: -8),
            shareButton.centerYAnchor.constraint(equalTo: rightBarView.centerYAnchor),
            rightBarView.heightAnchor.constraint(equalToConstant: 30),
            rightBarView.widthAnchor.constraint(equalToConstant: 70),
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarView)
    }

    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseID)
        tableView.register(
            FullDescriptionTableViewCell.self,
            forCellReuseIdentifier: FullDescriptionTableViewCell.reuseID
        )
        tableView.register(ShimmerCell.self, forCellReuseIdentifier: ShimmerCell.reuseID)
        tableView.register(PFCViewCell.self, forCellReuseIdentifier: PFCViewCell.reuseID)
        setConstraint()
    }

    private func setConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func returnCountCell() -> Int {
        switch state {
        case .data, .initial:
            return cellTypes.count
        case .loading:
            return 1
        default:
            return 0
        }
    }

    @objc private func addFavoritesRecipe() {
        presenter?.updateRecipeFavoriteStatus()
    }

    @objc private func backButtonAction() {
        presenter?.goBack()
    }

    @objc private func shareButtonAction() {
        presenter?.shareRecipe()
    }

    @objc private func refreshControlPulled(sender: UIRefreshControl) {
        state = .loading
        presenter?.fetchData()
        sender.endRefreshing()
    }

    @objc private func refreshButtonAction() {
        state = .loading
        presenter?.fetchData()
    }
}

// MARK: - DetailView + UITableViewDataSource

extension DetailView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        returnCountCell()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case .loading = state {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ShimmerCell.reuseID,
                for: indexPath
            ) as? ShimmerCell else { return UITableViewCell() }
            cell.startShimer()
            return cell
        } else {
            let item = cellTypes[indexPath.row]
            switch item {
            case .title:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TitleTableViewCell.reuseID,
                    for: indexPath
                ) as? TitleTableViewCell else { return UITableViewCell() }
                guard let recipe = presenter?.recipeDetail else { return cell }

                cell.setupView(recipe: recipe)
                return cell
            case .characteristics:
                guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: PFCViewCell.reuseID, for: indexPath) as? PFCViewCell
                else { return UITableViewCell() }
                guard let recipe = presenter?.recipeDetail else { return cell }
                cell.setupCell(with: recipe)
                return cell
            case .fullDescription:
                guard let cell = tableView
                    .dequeueReusableCell(
                        withIdentifier: FullDescriptionTableViewCell.reuseID,
                        for: indexPath
                    ) as? FullDescriptionTableViewCell
                else { return UITableViewCell() }
                guard let recipe = presenter?.recipeDetail else { return cell }
                cell.setupCell(recipe: recipe)
                return cell
            }
        }
    }
}

// MARK: - DetailView + DetailViewProtocol

extension DetailView: DetailViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }

    func updateFavoriteButton() {
        if let presenter {
            let image: UIImage = presenter.isFavorite ? .favoritesHig : .favorites
            favoritesButton.setImage(image, for: .normal)
        }
    }
}
