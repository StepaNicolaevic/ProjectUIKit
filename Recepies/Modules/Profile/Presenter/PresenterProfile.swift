// PresenterProfile.swift


import Foundation

/// Profile screen protocol
protocol ProfileViewProtocol: AnyObject {
    /// Calling an alert with a name change
    func showEditNameAlert()
    /// Calling a profile exit alert
    func showLogOutAlert()
    ///
    func showMap()
    /// Updating data in a table
    func reloadData()
    /// Opening the curtain with bonuses
    func openBunusView()
    /// Open the Terms screen
    func setupTermsView()
    /// Show editer image
    func showImageChooser()
}

/// Profile presenter protocol
protocol ProfilePresenterProtocol: AnyObject {
    /// Profile initialization
    init(view: ProfileViewProtocol, coordinator: BaseModuleCoordinator)
    /// Array of options
    var options: [OptionsProtocol] { get set }
    /// User information
    var user: User { get set }
    /// Loading an alert with a name change
    func setupAlert()
    /// Changing your profile name
    func setTitleNameUser(name: String)
    /// Cell selection
    func didSetectItem(index: Int)
    /// Exit profile
    func logOutProfile()
    /// Loading galery
    func setupGalery()
    /// Save avatar
    func saveAvatar(image: Data)
    /// Avatar data
    func avatarData() -> Data?
}

/// Презентер профиля
final class ProfilePresenter: ProfilePresenterProtocol {
    func avatarData() -> Data? {
        Caretaker.shared.loadImage()
    }

    // MARK: - Public Properties

    var options: [OptionsProtocol] = Options.makeOption()
    var user: User = Caretaker.shared.loadUser()

    // MARK: - Private Properties

    private weak var view: ProfileViewProtocol?
    private var coordinator: BaseModuleCoordinator?

    // MARK: - Initializers

    init(view: ProfileViewProtocol, coordinator: BaseModuleCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func saveAvatar(image: Data) {
        Caretaker.shared.saveImage(data: image)
        view?.reloadData()
    }

    func setupGalery() {
        view?.showImageChooser()
    }

    func setTitleNameUser(name: String) {
        Caretaker.shared.updateUserName(name: name)
        user = Caretaker.shared.loadUser()
        view?.reloadData()
    }

    func setupAlert() {
        view?.showEditNameAlert()
    }

    func didSetectItem(index: Int) {
        switch index {
        case 0:
            view?.openBunusView()
        case 1:
            view?.setupTermsView()
        case 2:
            view?.showLogOutAlert()
        case 3:
            if let profileCoordinator = coordinator as? ProfileCoordinator {
                profileCoordinator.showMapController()
            }
        default:
            break
        }
    }

    func logOutProfile() {
        if let profileCoordinator = coordinator as? ProfileCoordinator {
            profileCoordinator.logOut()
        }
    }
}
