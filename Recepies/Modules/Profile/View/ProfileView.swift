// ProfileView.swift


import UIKit

var titleProfile = Local.ProfileView.TitleLabel.text
/// Profile screen
final class ProfileView: UIViewController, UINavigationControllerDelegate {
    // MARK: - Types

    private enum CellTypes {
        /// Profile cell type
        case profile
        /// Option cell type
        case options
    }

    // MARK: - Constants

    private enum Constants {
        static let mainTableViewCellIdentifier = "MainTableViewCell"
        static let otherTableViewCellIdentifier = "OtherTableViewCell"
        static let veradanaBoldFont = "Verdana-Bold"
    }

    // MARK: - Public Properties

    var profilePresenter: ProfilePresenter?

    // MARK: - Private Properties

    private var termsView: TermsView!
    private var visualEffectView: UIVisualEffectView!
    private var tableView = UITableView()
    private let contentTypes: [CellTypes] = [.profile, .options]

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBar()
    }

    // MARK: - Private Methods

    private func setupNavBar() {
        let nameLabel = UIBarButtonItem(title: titleProfile, style: .plain, target: nil, action: nil)
        nameLabel.tintColor = .black
        nameLabel.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.veradanaBoldFont, size: 28) ?? UIFont
                    .systemFont(ofSize: 6),
            ],
            for: .normal
        )
        navigationItem.leftBarButtonItem = nameLabel
    }

    private func configureTable() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
        tableView.register(OtherTableViewCell.self, forCellReuseIdentifier: Constants.otherTableViewCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setConstarint()
    }

    private func setConstarint() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.backgroundColor = .white
    }
}

// MARK: - ProfileView + UITableViewDataSource

extension ProfileView: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        contentTypes.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countRow = contentTypes[section]
        switch countRow {
        case .profile:
            return 1
        case .options:
            return profilePresenter?.options.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = contentTypes[indexPath.section]
        switch items {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath
            )
                as? MainTableViewCell else { return UITableViewCell() }
            guard let profile = profilePresenter?.user else { return UITableViewCell() }
            cell.setupCell(profile: profile, data: profilePresenter?.avatarData() ?? Data())
            cell.editNameHandler = { [weak self] in
                self?.profilePresenter?.setupAlert()
            }

            cell.editAvatarHandler = { [weak self] in
                self?.profilePresenter?.setupGalery()
            }

            return cell
        case .options:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier:
                Constants.otherTableViewCellIdentifier,
                for: indexPath
            ) as? OtherTableViewCell
            else { return UITableViewCell() }
            guard let options = profilePresenter?.options else { return UITableViewCell() }
            cell.accessoryType = .disclosureIndicator
            cell.setupCell(options: options[indexPath.row])
            return cell
        }
    }
}

// MARK: - ProfileView + UITableViewDelegate

extension ProfileView: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = contentTypes[indexPath.section]
        switch items {
        case .options:
            profilePresenter?.didSetectItem(index: indexPath.row)
        default:
            break
        }
    }
}

// MARK: - ProfileView + ProfileViewProtocol

extension ProfileView: ProfileViewProtocol {
    func showImageChooser() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let chooseFromGalleryAction = UIAlertAction(title: Local.ProfileView.Galary.text, style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        actionSheet.addAction(chooseFromGalleryAction)

        let takePhotoAction = UIAlertAction(title: Local.ProfileView.TakePhoto.text, style: .default) { _ in
            self.showImagePicker(sourceType: .camera)
        }
        actionSheet.addAction(takePhotoAction)

        let cancelAction = UIAlertAction(title: Local.ProfileView.CancelAction.text, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    func showMap() {
        let mapViewContoller = MapViewController()
        present(mapViewContoller, animated: true)
        print("Тут должна быть открыться карта")
    }

    func setupTermsView() {
        termsView = TermsView(frame: CGRect(
            x: 0,
            y: view.frame.height / 2,
            width: view.bounds.width,
            height: view.bounds.height
        ))
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        let blurAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
        }
        blurAnimator.startAnimation()
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene

        UIView.animate(withDuration: 2) {
            windowScene?.windows.last?.addSubview(self.termsView)
        }
        termsView.closeViewHandler = { [weak self] in
            let blurAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
                self?.visualEffectView.effect = nil
            }
            blurAnimator.startAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.termsView.removeFromSuperview()
                self?.visualEffectView.removeFromSuperview()
            }
        }
    }

    func openBunusView() {
        let bonusPresenter = BonusPresenter()
        let bonusViewController = BonusViewController()
        if let sheet = bonusViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
        }
        bonusViewController.bonusPresenter = bonusPresenter
        bonusPresenter.view = bonusViewController
        present(bonusViewController, animated: true)
    }

    func showLogOutAlert() {
        let alert = UIAlertController(title: Local.ProfileView.ShowLogOut.text, message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: Local.ProfileView.YesAction.text, style: .default) { [weak self] _ in
            self?.profilePresenter?.logOutProfile()
        }
        let cancelAction = UIAlertAction(title: Local.ProfileView.CancelAction.text, style: .default)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func showEditNameAlert() {
        let alert = UIAlertController(title: Local.ProfileView.EditName.text, message: nil, preferredStyle: .alert)
        let conformAction = UIAlertAction(title: Local.ProfileView.ConformAction.text, style: .default) { [weak self] _ in
            if let text = alert.textFields?[0] {
                self?.profilePresenter?.setTitleNameUser(name: text.text ?? "")
            }
        }
        let cancelAction = UIAlertAction(title: Local.ProfileView.CancelAction.text, style: .default)
        alert.addTextField { textField in
            textField.placeholder = Local.ProfileView.TextFieldPlaceholder.text
        }

        alert.addAction(conformAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - ProfileView + UIImagePickerControllerDelegate

extension ProfileView: UIImagePickerControllerDelegate {
    func imagePickerController(
        _: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let selectedImage = info[.originalImage] as? UIImage {
            guard let saveImage = selectedImage.pngData() else { return }
            profilePresenter?.saveAvatar(image: saveImage)
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
