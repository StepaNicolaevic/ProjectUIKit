// FavoritesView.swift


import UIKit

/// Protocol for Favorites view
protocol FavoritesViewProtocol: AnyObject {
    /// View's presenter
    var presenter: FavoritesPresenterProtocol? { get }
    /// Reload tableView
    func updateTableView()
}

/// Screen to show and delete favorites recipes
final class FavoritesView: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let title = "Favorites"
        static let nothingText = "There's nothing here yet"
        static let addText = "Add interesting recipes to make ordering products convenient"
    }

    // MARK: - Visual components

    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.title
        label.font = .makeVerdanaBold(size: 28)
        return label
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
        return tableView
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(grayView)
        stack.addArrangedSubview(nothingLabel)
        stack.addArrangedSubview(addLabel)
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

    private let favoriteImageView = UIImageView(image: .favoriteSmall)

    private let nothingLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.nothingText
        label.font = .makeVerdanaBold(size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let addLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.addText
        label.font = .makeVerdanaRegular(size: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Public Properties

    var presenter: FavoritesPresenterProtocol?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIew()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEmptyNoticeVisibility()
        updateTableView()
    }

    // MARK: - Private Methods

    private func setupVIew() {
        view.backgroundColor = .systemBackground
        view.addSubviews(mainTitleLabel, recipesTableView, stackView)
        view.disableTARMIC()
        grayView.addSubview(favoriteImageView)
        grayView.disableTARMIC()
        setupConstraints()
    }

    private func setEmptyNoticeVisibility() {
        stackView.isHidden = (presenter?.recipes.count ?? 0) > 0
    }
}

// MARK: - FavoritesView - FavoritesViewProtocol

extension FavoritesView: FavoritesViewProtocol {
    func updateTableView() {
        recipesTableView.reloadData()
    }
}

// MARK: - Constraints

private extension FavoritesView {
    func setupConstraints() {
        setupTitleLabelConstraints()
        setupRecipesTableViewConstraints()
        setupStackViewConstraints()
        setupGrayViewConstraints()
        setupFavoriteImageViewConstraints()
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
    }

    func setupRecipesTableViewConstraints() {
        NSLayoutConstraint.activate([
            recipesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recipesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recipesTableView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 15),
            recipesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    func setupGrayViewConstraints() {
        NSLayoutConstraint.activate([
            grayView.heightAnchor.constraint(equalToConstant: 50),
            grayView.widthAnchor.constraint(equalTo: grayView.heightAnchor),
        ])
    }

    func setupFavoriteImageViewConstraints() {
        NSLayoutConstraint.activate([
            favoriteImageView.heightAnchor.constraint(equalToConstant: 24),
            favoriteImageView.widthAnchor.constraint(equalTo: favoriteImageView.heightAnchor),
            favoriteImageView.centerXAnchor.constraint(equalTo: grayView.centerXAnchor),
            favoriteImageView.centerYAnchor.constraint(equalTo: grayView.centerYAnchor),
        ])
    }
}

// MARK: - FavoritesView - UITableViewDelegate

extension FavoritesView: UITableViewDelegate {
    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        true
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            presenter?.removeRecipe(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            setEmptyNoticeVisibility()
        }
    }
}

// MARK: - FavoritesView - UITableViewDataSource

extension FavoritesView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter?.recipes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: CategoryViewCell.reuseID, for: indexPath) as? CategoryViewCell
        else { return .init() }
        let recipe = presenter?.recipes[indexPath.row]
        cell.setupCell(with: recipe)
        return cell
    }
}
