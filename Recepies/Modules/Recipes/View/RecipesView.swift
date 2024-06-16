// RecipesView.swift


import UIKit

// Recipe screen protocol
protocol RecipesViewProtocol: AnyObject {}
/// Screen with recipes
final class RecipesView: UIViewController {
    var presenter: RecipesPresenter?

    // MARK: - Constants

    private enum Constants {
        static let recipesCollectionViewCellIdentifier = "RecipesCollectionViewCell"
        static let veradanaFontBold = "Verdana-Bold"
    }

    // MARK: - Visual Components

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        configureCell()
        setConstraint()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deselectItem()
    }

    // MARK: - Private Methods

    private func deselectItem() {
        if let selectedIndex = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: selectedIndex, animated: false)
        }
    }

    private func setTitle() {
        let label = UILabel()
        label.text = Local.Recipes.SetTitle.text
        label.textAlignment = .left
        label.font = UIFont(name: Constants.veradanaFontBold, size: 28)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }

    private func configureCell() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(
            RecipesCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.recipesCollectionViewCellIdentifier
        )
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - CollectionPostTableViewCell + UICollectionViewDataSource

extension RecipesView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var itemSize = CGSize(width: 50, height: 50)
        switch indexPath.item % 7 {
        case 0, 1:
            itemSize = CGSize(width: view.bounds.width / 2.23, height: view.bounds.width / 2.23)
        case 2, 6:
            itemSize = CGSize(width: view.bounds.width / 1.56, height: view.bounds.width / 1.56)
        case 3, 4, 5:
            itemSize = CGSize(width: view.bounds.width / 3.54, height: view.bounds.width / 3.54)
        default:
            break
        }
        return itemSize
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.transitionToCategory(index: indexPath.item)
    }
}

extension RecipesView: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        presenter?.category.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.recipesCollectionViewCellIdentifier,
            for: indexPath
        ) as? RecipesCollectionViewCell else { return UICollectionViewCell() }
        guard let category = presenter?.category else { return cell }
        cell.setupCell(category: category[indexPath.item])
        return cell
    }
}

extension RecipesView: RecipesViewProtocol {}
