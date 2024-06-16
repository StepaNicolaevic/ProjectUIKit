// CategoryView.swift

import UIKit

/// Protocol for Category view
protocol CategoryViewProtocol: AnyObject {
    /// Type of handler from sorting button
    typealias SortingRecipeHandler = (Recipe, Recipe) -> Bool
    /// State of category screen, changes view appearance
    var state: CategoryState { get }
    /// View's presenter
    var presenter: CategoryPresenterProtocol? { get }
    /// Reload tableView
    func updateTableView()
    /// Set sorting buttons state .none
    func clearSortingButtonState()
    /// Set new state to view
    func updateState(with state: CategoryState)
}

/// View to show screen with recipes
final class CategoryView: UIViewController {
    // MARK: - Visual components

    private lazy var caloriesButton: SortingButton = makeSortingButton(
        title: Local.CategoryView.CaloriesButton.title,
        action: #selector(sortingButtonPressed)
    )
    private lazy var timeButton: SortingButton = makeSortingButton(
        title: Local.CategoryView.TimeButton.title,
        action: #selector(sortingButtonPressed)
    )

    private lazy var recipeSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Local.CategoryView.SearchPlaceholder.title
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.backgroundColor = .searchBackground
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var recipesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 114
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: CategoryViewCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refrechControlAction), for: .valueChanged)
        return refreshControl
    }()

    private lazy var errorView: ErrorView = {
        let view = ErrorView(state: .data, action: #selector(refreshButtonAction), view: self)
        return view
    }()

    // MARK: - Public Properties

    var presenter: CategoryPresenterProtocol?
    var state: CategoryState = .initial {
        didSet {
            print("State:", state)
            updateViewAppearance(for: state)
        }
    }

    // MARK: - Private properties

    private var shimmeringCells: [CategoryViewCell]?

    // MARK: - Life Cycle

    var timer: Timer?
    var startTime: Date?
    let timeInterval: TimeInterval? = 180
    var beginBackgroundTask: UIBackgroundTaskIdentifier?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIew()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            print(Date())
        })
        configureTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presenter?.dataSource == nil {
            presenter?.fetchData(searchText: "")
        }
    }

    func configureTimer() {
        beginBackgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let beginBackgroundTask = self?.beginBackgroundTask else { return }
            UIApplication.shared.endBackgroundTask(beginBackgroundTask)
            self?.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
        }

        startTime = Date()
        guard
            let startTime = startTime,
            let timeInterval = timeInterval,
            let beginBackgroundTask = beginBackgroundTask
        else { return }

        let leftSecond = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
        if leftSecond >= timeInterval {
            timer?.invalidate()
            timer = nil
            UIApplication.shared.endBackgroundTask(beginBackgroundTask)
            self.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
        }
    }

    // MARK: - Private Methods

    private func setupVIew() {
        view.backgroundColor = .systemBackground
        view.addSubviews(
            recipesTableView,
            timeButton,
            caloriesButton,
            recipeSearchBar,
            errorView
        )
        errorView.isHidden = true
        view.disableTARMIC()
        setNavigationItem()
        setupConstraints()
    }

    private func setNavigationItem() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setImage(.arrowLeft, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.text = presenter?.category.name
        titleLabel.font = .makeVerdanaBold(size: 28)
        titleLabel.textAlignment = .left

        let leftBarView = UIView()
        leftBarView.addSubviews(backButton, titleLabel)
        leftBarView.disableTARMIC()

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leftBarView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: leftBarView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: leftBarView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: leftBarView.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: leftBarView.trailingAnchor),
            leftBarView.heightAnchor.constraint(equalToConstant: 30),
        ])

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarView)
    }

    private func makeSortingButton(title: String, action: Selector) -> SortingButton {
        let button = SortingButton(title: title, height: 36)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func updateViewAppearance(for state: CategoryState) {
        refreshControl.endRefreshing()
        switch state {
        case .loading:
            recipesTableView.reloadData()
            shimmeringCells = recipesTableView.visibleCells as? [CategoryViewCell]
            shimmeringCells?.forEach { $0.startCellShimmerAnimation() }
            errorView.isHidden = true

        case .error, .noData:
            shimmeringCells?.forEach { $0.stopCellShimmerAnimation() }
            shimmeringCells = nil
            errorView.updateState(state)
            errorView.isHidden = false
            recipesTableView.reloadData()
        case .data:
            shimmeringCells?.forEach { $0.stopCellShimmerAnimation() }
            shimmeringCells = nil
            errorView.isHidden = true
            recipesTableView.reloadData()
        default:
            break
        }
    }

    @objc private func refreshButtonAction() {
        state = .loading
        presenter?.fetchData(searchText: "")
    }

    @objc private func backButtonAction() {
        presenter?.goBack()
    }

    @objc private func sortingButtonPressed() {
        let caloriesSortingHandler: SortingRecipeHandler?
        let timeSortingHandler: SortingRecipeHandler?

        if let caloriesButtonPredicate = caloriesButton.getSortingPredicate() {
            caloriesSortingHandler = { lhsRecipe, rhsRecipe in
                caloriesButtonPredicate(lhsRecipe.calories, rhsRecipe.calories)
            }
        } else { caloriesSortingHandler = nil }

        if let timePredicate = timeButton.getSortingPredicate() {
            timeSortingHandler = { lhsRecipe, rhsRecipe in
                timePredicate(lhsRecipe.timeToCook, rhsRecipe.timeToCook)
            }
        } else { timeSortingHandler = nil }

        presenter?.sortRecipesBy(caloriesSortingHandler, timeSortingHandler)
    }

    @objc private func refrechControlAction() {
        clearSortingButtonState()
        recipeSearchBar.text = ""
        presenter?.fetchData(searchText: "")
    }
}

// MARK: - CategoryView + UISearchBarDelegate

extension CategoryView: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        presenter?.searchRecipes(text: searchText)
    }
}

// MARK: - AuthView - CategoryViewProtocol

extension CategoryView: CategoryViewProtocol {
    func clearSortingButtonState() {
        caloriesButton.sortingState = .none
        timeButton.sortingState = .none
    }

    func updateTableView() {
        recipesTableView.reloadData()
    }

    func updateState(with state: CategoryState) {
        self.state = state
    }
}

// MARK: - Constraints

private extension CategoryView {
    func setupConstraints() {
        recipeSearchBarConstraints()
        setupRecipesTableViewConstraints()
        setupCaloriesButtonConstraints()
        setupTimeButtonConstraints()
        setupErrorViewConstraints()
    }

    func recipeSearchBarConstraints() {
        NSLayoutConstraint.activate([
            recipeSearchBar.leadingAnchor.constraint(equalTo: recipesTableView.leadingAnchor, constant: -8),
            recipeSearchBar.trailingAnchor.constraint(equalTo: recipesTableView.trailingAnchor, constant: 8),
            recipeSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
        ])
    }

    func setupCaloriesButtonConstraints() {
        NSLayoutConstraint.activate([
            caloriesButton.leadingAnchor.constraint(equalTo: recipesTableView.leadingAnchor),
            caloriesButton.topAnchor.constraint(equalTo: recipeSearchBar.bottomAnchor, constant: 20),
            caloriesButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    func setupTimeButtonConstraints() {
        NSLayoutConstraint.activate([
            timeButton.leadingAnchor.constraint(equalTo: caloriesButton.trailingAnchor, constant: 11),
            timeButton.topAnchor.constraint(equalTo: caloriesButton.topAnchor),
            timeButton.heightAnchor.constraint(equalTo: caloriesButton.heightAnchor),
        ])
    }

    func setupRecipesTableViewConstraints() {
        NSLayoutConstraint.activate([
            recipesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recipesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recipesTableView.topAnchor.constraint(equalTo: caloriesButton.bottomAnchor, constant: 13),
            recipesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func setupErrorViewConstraints() {
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - CategoryView - UITableViewDelegate

extension CategoryView: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showDetailedScreen(for: indexPath)
    }
}

// MARK: - CategoryView - UITableViewDataSource

extension CategoryView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch state {
        case .initial:
            return 0
        case .loading:
            return 10
        default:
            return presenter?.dataSource?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case .loading = state {}
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: CategoryViewCell.reuseID, for: indexPath) as? CategoryViewCell
        else { return .init() }
        if case .loading = state {
            return cell
        }
        let recipe = presenter?.dataSource?[indexPath.row]
        cell.setupCell(with: recipe)
        return cell
    }
}
