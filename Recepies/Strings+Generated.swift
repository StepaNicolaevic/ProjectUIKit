// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum Local {
    enum PFCView {
        enum Carbohydrates {
            /// Carbohydrates
            static let text = Local.tr("Localizable", "PFCView.carbohydrates.text", fallback: "Carbohydrates")
        }

        enum Fats {
            /// Fats
            static let text = Local.tr("Localizable", "PFCView.fats.text", fallback: "Fats")
        }

        enum Gram {
            ///  g
            static let text = Local.tr("Localizable", "PFCView.gram.text", fallback: " g")
        }

        enum KCal {
            ///  kcal
            static let text = Local.tr("Localizable", "PFCView.kCal.text", fallback: " kcal")
        }

        enum Kkal {
            /// Enerc kcal
            static let text = Local.tr("Localizable", "PFCView.kkal.text", fallback: "Enerc kcal")
        }

        enum Proteins {
            /// Proteins
            static let text = Local.tr("Localizable", "PFCView.proteins.text", fallback: "Proteins")
        }
    }

    enum AuthView {
        enum EmailLabel {
            /// Email Adress
            static let title = Local.tr("Localizable", "authView.emailLabel.title", fallback: "Email Adress")
        }

        enum EmailPlaceholder {
            /// Enter Email Address
            static let text = Local.tr("Localizable", "authView.emailPlaceholder.text", fallback: "Enter Email Address")
        }

        enum EmailWarning {
            /// Incorrect format
            static let text = Local.tr("Localizable", "authView.emailWarning.text", fallback: "Incorrect format")
        }

        enum LoginButton {
            /// Login
            static let title = Local.tr("Localizable", "authView.loginButton.Title", fallback: "Login")
        }

        enum LoginLabel {
            /// Localizable.strings
            ///   Recepies
            ///
            ///   Created by Степан Пахолков on 28.03.2024.
            static let title = Local.tr("Localizable", "authView.loginLabel.title", fallback: "Login")
        }

        enum PasswordLabel {
            /// Password
            static let title = Local.tr("Localizable", "authView.passwordLabel.title", fallback: "Password")
        }

        enum PasswordPlaceholder {
            /// Enter Password
            static let text = Local.tr("Localizable", "authView.passwordPlaceholder.text", fallback: "Enter Password")
        }

        enum PasswordWarning {
            /// You entered the wrong password
            static let text = Local.tr("Localizable", "authView.passwordWarning.text", fallback: "You entered the wrong password")
        }

        enum WarningLabel {
            /// Please check the accuracy of the entered credentials.
            static let text = Local.tr("Localizable", "authView.warningLabel.text", fallback: "Please check the accuracy of the entered credentials.")
        }
    }

    enum CategoryView {
        enum CaloriesButton {
            /// Calories
            static let title = Local.tr("Localizable", "categoryView.caloriesButton.title", fallback: "Calories")
        }

        enum SearchPlaceholder {
            /// Search recipes
            static let title = Local.tr("Localizable", "categoryView.searchPlaceholder.title", fallback: "Search recipes")
        }

        enum TimeButton {
            /// Time
            static let title = Local.tr("Localizable", "categoryView.timeButton.title", fallback: "Time")
        }
    }

    enum ProfileView {
        enum CancelAction {
            /// Cancel
            static let text = Local.tr("Localizable", "profileView.cancelAction.text", fallback: "Cancel")
        }

        enum ConformAction {
            /// OK
            static let text = Local.tr("Localizable", "profileView.conformAction.text", fallback: "OK")
        }

        enum EditName {
            /// Change your name and surname
            static let text = Local.tr("Localizable", "profileView.editName.text", fallback: "Change your name and surname")
        }

        enum Galary {
            /// Выбрать из галереи
            static let text = Local.tr("Localizable", "profileView.galary.text", fallback: "Выбрать из галереи")
        }

        enum ShowLogOut {
            /// Are you sure you want to log out?
            static let text = Local.tr("Localizable", "profileView.showLogOut.text", fallback: "Are you sure you want to log out?")
        }

        enum TakePhoto {
            /// Сделать фото
            static let text = Local.tr("Localizable", "profileView.takePhoto.text", fallback: "Сделать фото")
        }

        enum TextFieldPlaceholder {
            /// Name Surname
            static let text = Local.tr("Localizable", "profileView.textFieldPlaceholder.text", fallback: "Name Surname")
        }

        enum TitleLabel {
            /// Profile
            static let text = Local.tr("Localizable", "profileView.titleLabel.text", fallback: "Profile")
        }

        enum YesAction {
            /// Yes
            static let text = Local.tr("Localizable", "profileView.yesAction.text", fallback: "Yes")
        }
    }

    enum Recipes {
        enum SetTitle {
            /// Recipes
            static let text = Local.tr("Localizable", "recipes.setTitle.text", fallback: "Recipes")
        }
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Local {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
