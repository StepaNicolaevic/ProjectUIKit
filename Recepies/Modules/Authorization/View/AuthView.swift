// AuthView.swift

import GoogleMaps
import MyTextField
import UIKit

/// Protocol for Authorisation view
protocol AuthViewProtocol: AnyObject {
    /// View's presenter
    var presenter: AuthPresenterProtocol? { get set }
    /// Notify user if email format is incorrect
    /// - Parameter decision: defines necessity to notify the user
    func showIncorrectEmailFormat(_ decision: Bool)
    /// Notify user if password format is incorrect
    /// - Parameter decision: defines necessity to notify the user
    func showIncorrectPasswordFormat(_ decision: Bool)
    /// Notify user if email or password are not valid
    /// - Parameter decision: defines necessity to notify the user
    func showIncorrectUserData(_ decision: Bool)
    /// Set password textField in secure/nonsecure mode
    /// - Parameter decision: defines necessity to set secure
    func setPasswordSecured(isSecured: Bool)
}

/// View to show authorization screen
final class AuthView: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let defaultLoginButtonBottomConstraintValue = -37.0
    }

    // MARK: - Visual components

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.gradientBackground.cgColor]
        return gradientLayer
    }()

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = Local.AuthView.LoginLabel.title
        label.font = .makeVerdanaBold(size: 28)
        label.textColor = .darkGrayApp
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = Local.AuthView.EmailLabel.title
        label.font = .makeVerdanaBold(size: 18)
        label.textColor = .darkGrayApp
        return label
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = Local.AuthView.PasswordLabel.title
        label.font = .makeVerdanaBold(size: 18)
        label.textColor = .darkGrayApp
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = MyTextField.AuftarizationTextfield()
        textField.models(model: .init(placeholder: Local.AuthView.EmailPlaceholder.text))
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .whileEditing
        textField.leftView = makeLeftView(emailImageView)
        textField.leftViewMode = .always
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = MyTextField.AuftarizationTextfield()
        textField.models(model: .init(placeholder: Local.AuthView.PasswordPlaceholder.text))
        textField.rightView = makeRightView(secureImageView)
        textField.rightViewMode = .always
        textField.leftView = makeLeftView(lockImageView)
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var secureImageView: UIImageView = {
        let view = makeSubImageView(image: .eyeClose)
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(securePasswordButtonAction))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    private lazy var emailImageView = makeSubImageView(image: .email)
    private lazy var lockImageView = makeSubImageView(image: .lock)

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.setTitle(Local.AuthView.LoginButton.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .makeVerdanaRegular(size: 16)
        button.addTarget(nil, action: #selector(loginButtonAction), for: .touchUpInside)
        button.addSubview(activityIndicatorView)
        button.disableTARMIC()
        return button
    }()

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .redWarning
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.font = .makeVerdanaRegular(size: 18)
        label.textColor = .systemBackground
        label.text = Local.AuthView.WarningLabel.text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()

    private lazy var emailWarningLabel = makeAdviceRedLabel(title: Local.AuthView.EmailWarning.text)
    private lazy var passwordWarningLabel = makeAdviceRedLabel(title: Local.AuthView.PasswordWarning.text)
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.color = .white
        return view
    }()

    // MARK: - Public Properties

    var presenter: AuthPresenterProtocol?

    // MARK: - Private Properties

    var loginButtonBottomConstraint: NSLayoutConstraint?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIew()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsignFromKeyboarNotifications()
    }

    // MARK: - Private Methods

    private func setupVIew() {
        view.layer.addSublayer(gradientLayer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignTextFields))
        view.addGestureRecognizer(tapGesture)
        view.addSubviews(
            loginLabel,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            loginButton,
            warningLabel,
            emailWarningLabel,
            passwordWarningLabel
        )
        view.disableTARMIC()
        setupConstraints()
    }

    private func makeRightView(_ view: UIView) -> UIView {
        let rightView = UIView()
        rightView.addSubview(view)
        rightView.disableTARMIC()
        view.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -14).isActive = true
        view.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: 0).isActive = true
        view.centerYAnchor.constraint(equalTo: rightView.centerYAnchor).isActive = true
        return rightView
    }

    private func makeLeftView(_ view: UIView) -> UIView {
        let leftView = UIView()
        leftView.addSubview(view)
        leftView.disableTARMIC()
        view.trailingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: -13).isActive = true
        view.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: 17).isActive = true
        view.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        return leftView
    }

    private func makeSubImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.tintColor = .gray
        imageView.contentMode = .center
        return imageView
    }

    private func makeAdviceRedLabel(title: String) -> UILabel {
        let label = UILabel()
        label.font = .makeVerdanaBold(size: 12)
        label.textColor = .redWarning
        label.text = title
        label.isHidden = true
        return label
    }

    private func imitateNetworkRequest() {
        loginButton.setTitle("", for: .normal)
        activityIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.activityIndicatorView.stopAnimating()
            self.loginButton.setTitle(Local.AuthView.LoginButton.title, for: .normal)
            self.startUserDataValidation()
        }
    }

    private func startUserDataValidation() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        presenter?.validateUserData(email: email, password: password)
    }

    private func signToKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustUIForKeyboardPosition(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustUIForKeyboardPosition(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
    }

    private func unsignFromKeyboarNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    @objc private func adjustUIForKeyboardPosition(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        let keyboardFrame = keyboardValue.cgRectValue
        switch notification.name {
        case UIResponder.keyboardDidShowNotification:
            let actualConstant = -keyboardFrame.height
            loginButtonBottomConstraint?.constant = actualConstant
        case UIResponder.keyboardWillHideNotification:
            loginButtonBottomConstraint?.constant = Constants.defaultLoginButtonBottomConstraintValue
        default:
            return
        }
    }

    @objc private func securePasswordButtonAction() {
        presenter?.setPasswordeSecureStatus()
    }

    @objc func loginButtonAction() {
        resignTextFields()
        imitateNetworkRequest()
    }

    @objc func resignTextFields() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

// MARK: - AuthView - AuthViewProtocol

extension AuthView: AuthViewProtocol {
    func showIncorrectEmailFormat(_ decision: Bool) {
        switch decision {
        case true:
            emailWarningLabel.isHidden = false
            emailLabel.textColor = .redWarning
            emailTextField.layer.borderColor = UIColor.red.cgColor
        case false:
            emailWarningLabel.isHidden = true
            emailLabel.textColor = .darkGrayApp
            emailTextField.layer.borderColor = UIColor.darkGrayApp.cgColor
        }
    }

    func showIncorrectPasswordFormat(_ decision: Bool) {
        switch decision {
        case true:
            passwordWarningLabel.isHidden = false
            passwordLabel.textColor = .redWarning
            passwordTextField.layer.borderColor = UIColor.red.cgColor
        case false:
            passwordWarningLabel.isHidden = true
            passwordLabel.textColor = .darkGrayApp
            passwordTextField.layer.borderColor = UIColor.darkGrayApp.cgColor
        }
    }

    func showIncorrectUserData(_ decision: Bool) {
        if decision {
            UIView.animate(withDuration: 0.5, animations: {
                self.warningLabel.alpha = 1
            })
        } else {
            warningLabel.alpha = 0
        }
    }

    func setPasswordSecured(isSecured: Bool) {
        secureImageView.image = isSecured ? .eyeClose : .eyeOpen
        passwordTextField.isSecureTextEntry = isSecured
    }
}

// MARK: - Constraints

private extension AuthView {
    func setupConstraints() {
        setupLoginLabelConstraints()
        setupEmailLabelConstraints()
        setupEmailTextFieldConstraints()
        setupPasswordLabelConstraints()
        setupPasswordTextFieldConstraints()
        setupLoginButtonConstraints()
        setupWarningLabelConstraints()
        setupEmailWarningLabelConstraints()
        setupPasswordWarningLabelConstraints()
        setupActivityIndicatorConstraints()
    }

    func setupLoginLabelConstraints() {
        NSLayoutConstraint.activate([
            loginLabel.leadingAnchor.constraint(
                equalToSystemSpacingAfter: view.layoutMarginsGuide.leadingAnchor,
                multiplier: 1
            ),
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 82),
        ])
    }

    func setupEmailLabelConstraints() {
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            emailLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 23),
        ])
    }

    func setupEmailTextFieldConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    func setupPasswordLabelConstraints() {
        NSLayoutConstraint.activate([
            passwordLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 23),
        ])
    }

    func setupPasswordTextFieldConstraints() {
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 7),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    func setupLoginButtonConstraints() {
        loginButtonBottomConstraint = loginButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: Constants.defaultLoginButtonBottomConstraintValue
        )
        loginButtonBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    func setupWarningLabelConstraints() {
        NSLayoutConstraint.activate([
            warningLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            warningLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -49),
            warningLabel.heightAnchor.constraint(equalToConstant: 87),
        ])
    }

    func setupEmailWarningLabelConstraints() {
        NSLayoutConstraint.activate([
            emailWarningLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            emailWarningLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
        ])
    }

    func setupPasswordWarningLabelConstraints() {
        NSLayoutConstraint.activate([
            passwordWarningLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor),
            passwordWarningLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
        ])
    }

    func setupActivityIndicatorConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
        ])
    }
}

// MARK: - AuthView - UITextFieldDelegate

extension AuthView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == emailTextField else { return }
        presenter?.validateEmail(emailTextField.text ?? "")
    }

    func textFieldDidBeginEditing(_: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.warningLabel.alpha = 0
        }
    }
}
