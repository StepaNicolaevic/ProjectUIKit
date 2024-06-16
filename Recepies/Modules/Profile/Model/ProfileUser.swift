// ProfileUser.swift

// User profile
protocol ProfileUserProtocol {
    /// User's first and last name
    var userName: String { get set }
    /// User avatar
    var avatarImage: String { get set }
    /// The function creates a user
    static func makeProfile() -> Self
}

/// Protocol implementation
struct ProfileUser: ProfileUserProtocol {
    var userName: String
    var avatarImage: String
    static func makeProfile() -> ProfileUser {
        .init(userName: "", avatarImage: "avatar")
    }
}
