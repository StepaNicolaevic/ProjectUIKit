// AuthPresenter.swift

/// Protocol for Authorization screen presenter
protocol AuthPresenterProtocol: AnyObject {
    /// Main initializer
    init(view: AuthViewProtocol, authService: AuthServiceProtocol, coordinator: BaseModuleCoordinator)
    /// Validates user email adress and ask view to notify user if email is wrong
    /// - Parameter email: string value of user's email
    func validateEmail(_ email: String)
    /// Validates user email adress and password, ask view to notify user if email or password are wrong
    /// - Parameter email: string value of user's email
    /// - Parameter password: string value of user's password
    func validateUserData(email: String, password: String)
    /// Tell to view how to set secure entry status for password's textfield
    func setPasswordeSecureStatus()
}

final class AuthPresenter: AuthPresenterProtocol {
    // MARK: - Private Properties

    private weak var coordinator: BaseModuleCoordinator?
    private weak var view: AuthViewProtocol?
    private var authService: AuthServiceProtocol
    private var isPasswordSecured = true

    // MARK: - Initialization

    init(view: AuthViewProtocol, authService: AuthServiceProtocol, coordinator: BaseModuleCoordinator) {
        self.view = view
        self.authService = authService
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func validateEmail(_ email: String) {
        let (format, _) = authService.validateEmail(email)
        view?.showIncorrectEmailFormat(!format)
    }

    func validateUserData(email: String, password: String) {
        let (isEmailFormatOk, isEmailValid) = authService.validateEmail(email)
        let (isPasswordFormatOk, isPasswordValid) = authService.validatePassword(password)
        view?.showIncorrectUserData(!isEmailValid || !isPasswordValid)
        view?.showIncorrectPasswordFormat(!isPasswordFormatOk)
        view?.showIncorrectEmailFormat(!isEmailFormatOk)
        if isEmailValid, isPasswordValid, let coordinator = coordinator as? AuthCoordinator {
            coordinator.finishFlow()
        }
    }

    func setPasswordeSecureStatus() {
        isPasswordSecured.toggle()
        view?.setPasswordSecured(isSecured: isPasswordSecured)
    }
}
