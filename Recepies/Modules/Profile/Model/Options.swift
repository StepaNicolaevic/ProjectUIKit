// Options.swift

/// Name and picture of the profile option
protocol OptionsProtocol {
    /// Option icon
    var icon: String { get set }
    /// Option name
    var nameOptions: String { get set }
    /// Creates an array of options
    static func makeOption() -> [Self]
}

/// Reflation of the protocol
struct Options: OptionsProtocol {
    var icon: String
    var nameOptions: String
    static func makeOption() -> [Options] {
        [
            .init(icon: "star", nameOptions: "Bonuses"),
            .init(icon: "termsF", nameOptions: "Terms & Privacy Policy"),
            .init(icon: "logoutF", nameOptions: "Log out"),
            .init(icon: "gift-alt", nameOptions: "Our Partners"),
        ]
    }
}
