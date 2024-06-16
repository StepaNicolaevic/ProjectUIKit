// Caretaker.swift


import Foundation

/// Class conteiner
final class Caretaker {
    static let shared = Caretaker()

    // MARK: - Private Properties

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let keyUser = "user"
    private let keyAvatar = "avatar"
    private var user: User = .init(login: "", password: "", nickName: "", avatar: "") {
        didSet {
            save(records: user)
        }
    }

    // MARK: - Public Methods

    func updateLogin(login: String) {
        user.login = login
    }

    func updatePassword(password: String) {
        user.password = password
    }

    func updateUserName(name: String) {
        user.nickName = name
    }

    func loadUser() -> User {
        user = load() ?? User(login: "", password: "", nickName: "", avatar: "")
        return user
    }

    func saveImage(data: Data) {
        do {
            let encoded = try PropertyListEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: keyUser)
        } catch {
            print(error)
        }
    }

    func loadImage() -> Data? {
        guard let data = UserDefaults.standard.data(forKey: keyUser) else {
            return nil
        }
        do {
            return try PropertyListDecoder().decode(Data.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }

    // MARK: - Private Methods

    private func save(records: User) {
        do {
            let data = try encoder.encode(records)
            UserDefaults.standard.set(data, forKey: keyAvatar)
        } catch {
            print(error)
        }
    }

    private func load() -> User? {
        guard let data = UserDefaults.standard.data(forKey: keyAvatar) else {
            return nil
        }
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
