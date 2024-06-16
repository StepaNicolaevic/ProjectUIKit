// AuthService.swift


import UIKit

/// Protocol for user authorisation service
protocol AuthServiceProtocol {
    /// Email validation
    /// - Parameter email: string value of user email
    /// - Returns: isFormatOk: True if email value contains charackters as @, ., etc. False if not
    /// - Returns: isValid: True if email fit to user email. False if not
    func validateEmail(_ email: String) -> (isFormatOk: Bool, isValid: Bool)

    /// Passwordl validation
    /// - Parameter password: string value of user pasword
    /// - Returns: isFormatOk: True if password lenght > 5. False if not
    /// - Returns: isValid: True if password fit to user password. False if not
    func validatePassword(_ password: String) -> (isFormatOk: Bool, isValid: Bool)
}

/// Service for user authorization
final class AuthService: AuthServiceProtocol {
    func validateEmail(_ email: String) -> (isFormatOk: Bool, isValid: Bool) {
        let isFormatOk = email.contains { character in
            character == "@"
        }

        var isValid: Bool
        let userLogin = Caretaker.shared.loadUser().login

        if userLogin.isEmpty {
            Caretaker.shared.updateLogin(login: email)
        }
        isValid = Caretaker.shared.loadUser().login == email

        return (isFormatOk, isValid)
    }

    func validatePassword(_ password: String) -> (isFormatOk: Bool, isValid: Bool) {
        let isFormatOk = password.count > 5

        var isValid: Bool
        let userPassword = Caretaker.shared.loadUser().password

        if userPassword.isEmpty {
            Caretaker.shared.updatePassword(password: password)
        }
        isValid = Caretaker.shared.loadUser().password == password

        return (isFormatOk, isValid)
    }
}
