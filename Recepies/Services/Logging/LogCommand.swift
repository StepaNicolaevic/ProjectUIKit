// LogCommand.swift


import Foundation

/// Describes types of possible log commands
public enum LogCommand {
    /// User did open screen with name (string value)
    case openScreen(screenName: String)
    /// User did move  from category with name (first string value) to screen with name (second string value)
    case move(fromCategory: String, toScreen: String)
    /// User did open recipe with name (string value)
    case openRecipe(recipeName: String)
    /// User did share recipe with name (string value)
    case shareRecipe(recipeName: String)
    /// Return message for writing to log
    var logMessage: String {
        var message = makeDateStamp() + " "
        switch self {
        case let .openScreen(screenName):
            message += "User open \(screenName) screen"
        case let .move(fromCategory, toScreen):
            message += "User moved from \(fromCategory) category to \(toScreen) screen"
        case let .openRecipe(recipeName):
            message += "User open \(recipeName) recipe"
        case let .shareRecipe(recipeName):
            message += "User share \(recipeName) recipe"
        }
        return message
    }

    /// Makes string with current date information
    private func makeDateStamp() -> String {
        let dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
}

/// Start log writing activities
public func log(_ command: LogCommand) {
    LoggerInvoker.shared.addLogCommand(command)
}
